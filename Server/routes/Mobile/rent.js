const express = require('express')
const PDFDocument = require('pdfkit');

const router = express.Router()
const passport = require('passport')
const rentCtrl = require("../../controllers/Mobile/rent")
const userCtrl = require("../../controllers/Mobile/user")
const itemCtrl = require("../../controllers/Common/items")
const transporter = require('../../middleware/transporter')
const containerCtrl = require('../../controllers/Common/container')

function formatDate(date) {
  const day = date.getDate();
  const month = date.getMonth() + 1; // +1 car les mois commencent à 0
  const year = date.getFullYear();
  const hours = date.getHours();
  const minutes = date.getMinutes();

  const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;

  return formattedDate;
}

function drawTable(doc, tableData) {
  const startY = doc.y;
  const startX = doc.x;
  const cellPadding = 5;
  const fontSize = 12;
  const tableWidth = 500;

  const columnWidth = tableWidth / tableData[0].length;

  tableData.forEach((row, i) => {
    row.forEach((cell, j) => {
      doc.fontSize(fontSize).text(cell, startX + j * columnWidth, startY + i * (fontSize + cellPadding), { width: columnWidth, align: 'center' });
    });
  });

  const tableHeight = tableData.length * (fontSize + cellPadding);

  doc.rect(startX, startY, tableWidth, tableHeight).stroke();
}

async function generateInvoice(
  email,
  date,
  duration,
  containerAddress,
  containerCity,
  itemInfo,
  clientInfo,
  price,
  totalPriceHT,
  totalPriceTTC
) {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const buffers = [];

    doc.on('error', (error) => {
      reject(error);
    });

    doc.on('data', buffers.push.bind(buffers));
    doc.on('end', () => {
      const pdfData = Buffer.concat(buffers);
      resolve(pdfData);
    });

    doc.text('Facture de location', { align: 'center', size: 18 });

    doc.moveDown();
    doc.text(`Date de location: ${formatDate(date)}`, { align: 'left' });
    doc.text(`Durée de location: ${duration} heures`, { align: 'left' });
    doc.text(`Adresse du conteneur: ${containerAddress}, ${containerCity}`, { align: 'left' });
    doc.text(`Informations sur le client: ${clientInfo}`, { align: 'left' });
    doc.text(`Email du client: ${email}`, { align: 'left' });

    doc.moveDown();
    const tableData = [
      ['Article', 'Prix unitaire', 'Quantité', 'Prix total HT', 'Prix total TTC'],
      [itemInfo, price, duration, totalPriceHT, totalPriceTTC]
    ];
    drawTable(doc, tableData);

    doc.moveDown();
    doc.text('Merci pour votre confiance!', { align: 'center' });

    doc.end();
  });
}

async function sendEmailConfirmationLocation(
  email,
  date,
  duration,
  address,
  city,
  itemId,
  price
) {
  try {
    const formattedDate = formatDate(date);
      const mailOptions = {
        from: process.env.SMTP_EMAIL,
        to: email,
        subject: 'Confirmation de votre location',
        text: 'Votre location a bien été enregistrée. \n Vous avez loué l\'article ' + itemId + ' pour une durée de ' + duration + ' heures le ' + formattedDate + ' dans le conteneur situé à l\'addresse suivante :  ' + address + ', ' + city + '. \n Le prix total est de ' + price + ' euros. Vous pouvez demander une facture en consultant la location.\nMerci de votre confiance.',
      }

    await transporter.sendMail(mailOptions)
  } catch (error) {
    console.error('Error sending location confirmation email:', error)
  }
}

async function sendInvoice(invoiceData, email) {
  try {
    const mailOptions = {
      from: process.env.SMTP_EMAIL,
      to: email,
      subject: 'Facture de votre location',
      text: 'Veuillez trouver la facture de votre location en pièce jointe.',
      attachments: [
        {
          filename: 'facture.pdf',
          content: invoiceData,
        },
      ],
    };

    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('Error sending location invoice email:', error);
    throw error;
  }
}

router.post('/article',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.body.itemId || req.body.itemId === '') {
        return res.status(401).json({ message: 'Missing itemId' })
      }

      const item = await itemCtrl.getItemFromId(parseInt(req.body.itemId))
      if (!item) {
        return res.status(401).send('Item not found');
      }
      if (!req.body.duration || req.body.duration < 0) {
        return res.status(401).json({ message: 'Missing duration' })
      }
      if (!item.available) {
        return res.status(401).send('Item not available');
      }
      const locationPrice = item.price * req.body.duration

      await itemCtrl.updateItem(item.id, {
        price: item.price,
        available: false
       })

      const location = await rentCtrl.rentItem(
        locationPrice,
        item.id,
        user.id,
        parseInt(req.body.duration)
      )


      const container = await containerCtrl.getContainerById(item.containerId);

      sendEmailConfirmationLocation(
        user.email,
        new Date(),
        req.body.duration,
        container.address,
        container.city,
        item.name,
        locationPrice
      );

      var clientInfo = null;
      if (user.firstName == null || user.lastName == null) {
        clientInfo = 'Non renseigné';
      } else {
        clientInfo = user.firstName + ' ' + user.lastName;
      }

      const invoiceData = await generateInvoice(
        user.email,
        new Date(),
        req.body.duration,
        container.address,
        container.city,
        item.name,
        clientInfo,
        item.price,
        locationPrice,
        locationPrice,
      );

      await sendInvoice(invoiceData, user.email);

      await rentCtrl.updateRentInvoice(location.id, invoiceData);

      return res.status(201).json({ message: 'location saved' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred' + err.message)
    }
  }
)

router.get('/invoice/:locationId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }

      const locationId = req.params.locationId;

      const location = await rentCtrl.getRentFromId(parseInt(locationId))

      if (!location) {
        return res.status(404).send('Location not found');
      }

      if (!location.invoice) {
        return res.status(404).send('Invoice not found');
      }

      //sendInvoice(location.invoice, user.email);

      return res.status(201).json({ message: 'invoice sent' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.get('/listAll',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found')
      }
      const rentals = await rentCtrl.getUserRents(user.id)
      return res.status(200).json({ rentals: rentals })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.get('/:rentId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.params.rentId || req.params.rentId == '') {
        return res.status(401).json({ message: 'Missing rentId' })
      }
      const rental = await rentCtrl.getRentFromId(parseInt(req.params.rentId))
      if (!rental) {
        return res.status(401).send('Location not found')
      }
      if (rental.userId != req.user.id) {
        return res.status(401).send('Location from wrong user')
      }
      return res.status(201).json({ rental: rental })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.post('/:rentId/return',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      if (!req.params.rentId || req.params.rentId == '') {
        return res.status(401).json({ message: 'Missing rentId' })
      }
      const rent = await rentCtrl.getRentFromId(parseInt(req.params.rentId))
      if (!rent) {
        return res.status(401).send('Location not found')
      }
      if (rent.userId != req.user.id) {
        return res.status(401).send('Location from wrong user')
      }
      await rentCtrl.returnRent(parseInt(req.params.rentId))
      return res.status(201).json({ message: 'location returned' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)


module.exports = router
