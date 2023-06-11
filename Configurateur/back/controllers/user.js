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

exports.findUserByUuid = uuid => {
  return db.User.findUnique({
    where: {
      uuid
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
        '<p>Bonjour, merci de vous être inscrit sur notre site, Veuillez cliquer sur le lien suivant pour confirmer votre inscription: <a href="http://localhost:80/#/confirmed-user/' +
        generatedUuid +
        '">Confirmer</a>' +
        '</p>'
    }
    transporter.sendMail(mail)
  })
}

exports.confirmedRegister = uuid => {
  return db.User.update({
    where: {
      uuid: uuid
    },
    data: {
      confirmed: true
    }
  })
}

exports.loginByEmail = user => {
  return db.User.findUnique({
    where: {
      email: user.email
    }
  }).then(findUser => {
    if (!bcrypt.compareSync(user.password, findUser.password)) {
      throw new Error('Invalid password')
    }

    return findUser
  })
}

exports.updatePassword = user => {
  user.password = bcrypt.hashSync(user.password, 12)
  return db.User.update({
    where: {
      uuid: user.uuid
    },
    data: {
      password: user.password
    }
  })
}

exports.forgotPassword = email => {
  let generatedUuid = ''
  this.findUserByEmail(email).then(user => {
    console.log(user)
    generatedUuid = user.uuid
    let mail = {
      from: 'risu.epitech@gmail.com',
      to: email,
      subject: 'Réinitialisation de mot de passe',
      html:
        '<p>Bonjour, pour réinitialiser votre mot de passe, Veuillez cliquer sur le lien suivant: <a href="http://localhost:80/#/password-change/' +
        generatedUuid +
        '">Réinitialiser le mot de passe</a>' +
        '</p>'
    }
    transporter.sendMail(mail)
  })
}
