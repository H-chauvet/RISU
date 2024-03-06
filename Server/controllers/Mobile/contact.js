const { db } = require('../../middleware/database')

/**
 * Create a object with the message sent from a mobile user
 *
 * @param {string} name
 * @param {string} email
 * @param {string} message
 * @returns the contact object
 */
exports.createContact = (name, email, message) => {
    return db.Contact_Mobile.create({
      data: {
          name: name,
          email: email,
          message: message
      }
    })
}
