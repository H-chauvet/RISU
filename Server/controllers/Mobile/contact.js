const { db } = require('../../middleware/database')

exports.createContact = (name, email, message) => {
    return db.Contact_Mobile.create({
      data: {
          name: name,
          email: email,
          message: message
      }
    })
}
