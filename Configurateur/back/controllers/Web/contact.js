const { db } = require('../../middleware/database')

exports.registerMessage = data => {
    return db.Contact_Web.create({
      data: data
    })
  }