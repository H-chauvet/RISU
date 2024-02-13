const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const { db } = require('../../middleware/database')
const uuid = require('uuid')
const transporter = require('../../middleware/transporter')

/**
 *
 * Find user by id
 *
 * @param {*} id of the user
 * @returns user finded by id
 */
exports.findUserById = id => {
  return db.User_Mobile.findUnique({
    where: {
      id: id
    }
  })
}

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

exports.getAllUsers = async () => {
  try {
    const users = await db.User_Mobile.findMany();
    return users;
  } catch (error) {
    console.error('Error retrieving mobile users:', error);
    throw new Error('Failed to retrieve mobile users');
  }
};