const { db } = require('../../middleware/database')

/**
 * Create a message sent from the web
 *
 * @param {*} data of the contact to be created
 * @returns the newly created contact
 */
exports.registerMessage = data => {
    return db.Contact_Web.create({
      data: data
    })
  }
