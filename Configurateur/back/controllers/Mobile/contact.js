const { db } = require('../../middleware/database')

exports.createContact = (name, email, message) => {
    return db.Contact.create({
    data: {
        name: name,
        email: email,
        message: message
    }
    })
}