const { db } = require('../../middleware/database')
const transporter = require('../../middleware/transporter')

exports.sendAccountConfirmationEmail = (email, token) => {
  let mailOptions = {
    from: process.env.MAIL_ADDRESS,
    to: email,
    subject: 'Confirm your account',
    text:
      'Please follow the link to confirm your account: http://51.103.94.191:8080/api/mailVerification?token=' +
      token
  }
  try {
    transporter.sendMail(mailOptions)
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}

exports.verifyEmail = id => {
  return db.User_Mobile.update({
    where: {
      user: user.id
    },
    data: {
      mailVerification: true
    }
  })
}
