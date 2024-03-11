const { formatDate } = require("../../invoice/invoiceUtils");
const transporter = require("../../middleware/transporter");

/**
 * Send an email to the user to confirm a rent
 *
 * @param {*} email of the user
 * @param {*} date of the rent
 * @param {*} duration of the rent
 * @param {*} address of the container for the rent
 * @param {*} city of the container for the rent
 * @param {*} itemId of the rent
 * @param {*} price of the item of the rent
 */
async function sendEmailConfirmationLocation(
  email,
  date,
  duration,
  address,
  city,
  itemId,
  price,
) {
  try {
    const formattedDate = formatDate(date);
    const mailOptions = {
      from: process.env.SMTP_EMAIL,
      to: email,
      subject: "Confirmation de votre location",
      text:
        "Votre location a bien été enregistrée. \nVous avez loué l'article " +
        itemId +
        " pour une durée de " +
        duration +
        " heures le " +
        formattedDate +
        " dans le conteneur situé à l'adresse suivante :  " +
        address +
        ", " +
        city +
        ". \nLe prix total est de " +
        price +
        " euros. Vous pouvez demander une facture en consultant la location.\nMerci de votre confiance.",
    };

    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error("Error sending location confirmation email:", error);
  }
}

/**
 * Send the mail with the invoice inside
 *
 * @param {*} invoiceData the invoice file
 * @param {*} email of the user
 */
async function sendInvoice(invoiceData, email) {
  try {
    const mailOptions = {
      from: process.env.SMTP_EMAIL,
      to: email,
      subject: "Facture de votre location",
      text: "Bonjour,\n\nSuite à votre demande, Vous trouverez la facture de votre location en pièce jointe.\nNous vous remercions pour votre confiance.\n\nCordialement,\nL'équipe RISU.",
      attachments: [
        {
          filename: "facture.pdf",
          content: invoiceData,
        },
      ],
    };

    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error("Error sending location invoice email:", error);
    throw error;
  }
}

module.exports = {
  sendEmailConfirmationLocation,
  sendInvoice,
};
