const { db } = require('../../middleware/database')

/**
 * Create an object with the message sent from a mobile user
 *
 * @param {string} name of the user
 * @param {string} email of the user
 * @param {string} message sent by the user
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
