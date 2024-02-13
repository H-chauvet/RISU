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

exports.setTemporaryUserPassword = (user, clearPassword) => {
  const password = bcrypt.hashSync(clearPassword, 12)
  return db.User_Mobile.update({
    where: {
      user: user.id
    },
    data: {
      password: password,
    }
  })
}

exports.deleteUser = id => {
  return db.User_Mobile.delete({
    where: {
      id: id
    }
  })
}
