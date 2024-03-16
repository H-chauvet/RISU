const bcrypt = require('bcrypt')
const { db } = require('../../middleware/database')
const transporter = require('../../middleware/transporter')

/**
 * Find user by id
 *
 * @param {*} id of the user
 * @returns user found by id
 */
exports.findUserById = id => {
  return db.User_Mobile.findUnique({
    where: {
      id: id
    },
    include: {
      Notifications: true,
    }
  })
}

/**
 * Find user by email
 *
 * @param {*} email of the user
 * @returns user found by email
 */
exports.findUserByEmail = email => {
  return db.User_Mobile.findUnique({
    where: {
      email: email
    }
  })
}

/**
 * Retrieve every mobile user of the database
 *
 * @returns every user found
 */
exports.getAllUsers = async () => {
  try {
    const users = await db.User_Mobile.findMany();
    return users;
  } catch (error) {
    console.error('Error retrieving mobile users:', error);
    throw new Error('Failed to retrieve mobile users');
  }
}

/// WILL BE REMOVED (HUGO TASK)
exports.generateRandomPassword = (length) => {
  const characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@m!$%&*?'
  let password = ''
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length)
    password += characters.charAt(randomIndex)
  }
  return password
}

exports.sendResetPasswordEmail = async(email, newPassword) => {
  const mailOptions = {
    from: process.env.MAIL_ADDRESS,
    to: email,
    subject: 'Reset Your Password',
    text: `Your new password is: ${newPassword}`
  }

  try {
    const info = transporter.sendMail(mailOptions)
    console.log('Reset email sent to ' + email + ' (' + info.response + ')')
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}

/// END OF WILL BE REMOVED

/**
 * Modify the password of an user
 *
 * @param {*} user object
 * @param {*} newPassword new password of the user
 * @returns the updated user
 */
exports.setNewUserPassword = (user, newPassword) =>{
  const password = bcrypt.hashSync(newPassword, 12)
  return db.User_Mobile.update({
    where: {
      id: user.id
    },
    data: {
      password: password,
    }
  })
}

/**
 * Delete an user from the database
 *
 * @param {number} id of the user to be deleted
 * @returns none
 */
exports.deleteUser = id => {
  return db.User_Mobile.delete({
    where: {
      id: id
    }
  })
}

/**
 * Update the data of the user
 *
 * @param {*} user object to be updated
 * @param {*} body where the updated data can be found
 * @returns the updated user object
 */
exports.updateUserInfo = (user, body) => {
  return db.User_Mobile.update({
    where: { id: user.id },
    data: {
      firstName: body.firstName ?? user.firstName,
      lastName: body.lastName ?? user.lastName,
      email: body.email ?? user.email,
      Notifications: {
        update: {
          favoriteItemsAvailable: body.favoriteItemsAvailable ?? user.Notifications.favoriteItemsAvailable,
          endOfRenting: body.endOfRenting ?? user.Notifications.endOfRenting,
          newsOffersRisu: body.newsOffersRisu ?? user.Notifications.newsOffersRisu
        }
      }
    },
    include: { Notifications: true }
  })
}

exports.getFullName = (userId) => {
  const user = db.User_Mobile.findUnique({
    where: { id: userId },
    select: { firstName: true, lastName: true }
  })
  if (!user) return null
  if (!user.firstName && !user.lastName) return 'Non renseigné'
  return user.firstName + ' ' + user.lastName
}
