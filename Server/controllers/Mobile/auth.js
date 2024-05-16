const { db } = require('../../middleware/database')
const transporter = require('../../middleware/transporter')

/**
 * Send an email to verify the account of a mobile user
 *
 * @param {string} email of the new user
 * @param {string} token of the new user
 */
exports.sendAccountConfirmationEmail = (email, token) => {
  let mailOptions = {
    from: process.env.MAIL_ADDRESS,
    to: email,
    subject: 'Confirm your account',
    text: "",
    html: '<p>Please follow the link to confirm your account: <a href="http://risu.dns-dynamic.net:3000/api/mobile/auth/mailVerification?token=' +
      token + '">here</a></p>',
  }
  try {
    transporter.sendMail(mailOptions)
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}

/**
 * Update the email verification status of the user to true
 *
 * @param {number} id of the user
 * @returns the updated user
 */
exports.verifyEmail = id => {
  return db.User_Mobile.update({
    where: {
      id: id
    },
    data: {
      mailVerification: true
    }
  })
}

/**
 * Send an email to verify New email of a mobile user
 *
 * @param {string} email of the new user
 * @param {string} token of the new user
 */
exports.sendConfirmationNewEmail = (email, token) => {
  let mailOptions = {
    from: process.env.MAIL_ADDRESS,
    to: email,
    subject: 'Confirm your New Email',
    text: "",
    html: '<p>Please follow the link to confirm your New email: <a href="http://risu.dns-dynamic.net:3000/api/mobile/auth/newEmailVerification?token=' +
      token + '">here</a></p>',
  }
  try {
    transporter.sendMail(mailOptions)
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}