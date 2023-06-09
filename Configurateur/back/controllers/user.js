const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const { db } = require('../middleware/database')
const uuid = require('uuid')
const transporter = require('../middleware/transporter')

exports.findUserByEmail = email => {
  return db.User.findUnique({
    where: {
      email
    }
  })
}

exports.findUserById = id => {
  return db.User.findUnique({
    where: {
      id
    }
  })
}

exports.registerByEmail = user => {
  user.password = bcrypt.hashSync(user.password, 12)
  user.uuid = uuid.v4()
  return db.User.create({
    data: user
  })
}

exports.registerConfirmation = email => {
  let generatedUuid = ''
  this.findUserByEmail(email).then(user => {
    console.log(user)
    generatedUuid = user.uuid
    let mail = {
      from: 'risu.epitech@gmail.com',
      to: email,
      subject: "Confirmation d'inscription",
      html:
        '<p>Bonjour, merci de vous être inscrit sur notre site, Veuillez cliquer sur le lien suivant pour confirmer votre inscription: <a href="http://localhost:80/' +
        generatedUuid +
        '">Confirmer</a>' +
        '</p>'
    }
    transporter.sendMail(mail)
  })
}

exports.confirmedRegister = email => {
  return db.User.update({
    where: {
      email: email
    },
    data: {
      confirmed: true
    }
  })
}
