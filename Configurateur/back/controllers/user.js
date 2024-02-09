const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const { db } = require('../middleware/database')
const uuid = require('uuid')
const transporter = require('../middleware/transporter')

/**
 *
 * Find user by email
 *
 * @param {*} email of the user
 * @returns user finded by email
 */
exports.findUserByEmail = email => {
  return db.User.findUnique({
    where: {
      email
    }
  })
}

/**
 *
 * Find user by uuid
 *
 * @param {*} uuid of the user
 * @returns user finded by uuid
 */
exports.findUserByUuid = uuid => {
  return db.User.findUnique({
    where: {
      uuid
    }
  })
}

/**
 *
 * Find user by id
 *
 * @param {*} id of the user
 * @returns user finded by id
 */
exports.findUserById = id => {
  return db.User.findUnique({
    where: {
      id
    }
  })
}

/**
 *
 * Delete a user
 *
 * @param {*} email of user to delete
 * @returns user deleted
 */
exports.deleteUser = email => {
  return db.User.delete({
    where: {
      email
    }
  })
}

/**
 *
 * Create new user
 *
 * @param {*} user information
 * @returns created user object
 */
exports.registerByEmail = user => {
  user.password = bcrypt.hashSync(user.password, 12)
  user.uuid = uuid.v4()
  return db.User.create({
    data: user
  })
}

/**
 *
 * Define the mail object for register confirmation and call associate middleware
 *
 * @param {*} email of the receiver
 */
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
        '<p>Bonjour, merci de vous être inscrit sur notre site, Veuillez cliquer sur le lien suivant pour confirmer votre inscription: <a href="http://51.103.94.191:80/#/confirmed-user/' +
        generatedUuid +
        '">Confirmer</a>' +
        '</p>'
    }
    transporter.sendMail(mail)
  })
}

/**
 *
 * Set confirmed at true
 *
 * @param {*} uuid
 * @returns user object
 */
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

/**
 *
 * Authentification of an user
 *
 * @param {*} user
 * @returns user object logged in
 */
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

/**
 *
 * Update password
 *
 * @param {*} user
 * @returns user object with updated password
 */
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

/**
 *
 * Define the mail object for password change and call associate middleware
 *
 * @param {*} email of the receiver
 */
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
        '<p>Bonjour, pour réinitialiser votre mot de passe, Veuillez cliquer sur le lien suivant: <a href="http://51.103.94.191:80/#/password-change/' +
        generatedUuid +
        '">Réinitialiser le mot de passe</a>' +
        '</p>'
    }
    transporter.sendMail(mail)
  })
}

exports.getAllUsers = async () => {
  try {
    const users = await db.User.findMany();
    return users;
  } catch (error) {
    console.error('Error retrieving users:', error);
    throw new Error('Failed to retrieve users');
  }
};

/**
 *
 * Find user details by email (including first name and last name)
 *
 * @param {*} email of the user
 * @returns user details (including first name and last name)
 */
exports.findUserDetailsByEmail = email => {
  return db.User.findUnique({
    where: {
      email
    },
    select: {
      id: true,
      firstName: true,
      lastName: true,
      createdAt: true,
      company: true,
      email: true,
    }
  });
};

/**
 *
 * Update firstName and LastName
 *
 * @param {*} user
 * @returns user object with updated firstName and lastName
 */
exports.updateName = user => {
  return db.User.update({
    where: {
      email: user.email
    },
    data: {
      firstName: user.firstName,
      lastName: user.lastName,
    }
  })
}

/**
 *
 * Update mail
 *
 * @param {*} user
 * @returns user object with updated mail
 */
exports.updateMail = user => {
  return db.User.update({
    where: {
      email: user.oldMail
    },
    data: {
      email: user.newMail,
    }
  })
}

/**
 *
 * Update company
 *
 * @param {*} user
 * @returns user object with updated company
 */
exports.updateCompany = user => {
  return db.User.update({
    where: {
      email: user.email
    },
    data: {
      company: user.company,
    }
  })
}

/**
 *
 * Update company
 *
 * @param {*} user
 * @returns user object with updated company
 */
exports.updateUserPassword = user => {
  user.password = bcrypt.hashSync(user.password, 12)
  return db.User.update({
    where: {
      email: user.email
    },
    data: {
      password: user.password,
    }
  })
}
