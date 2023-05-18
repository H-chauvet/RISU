const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const { db } = require('../middleware/database')

exports.findUserByEmail = email => {
  return db.User.findUnique({
    where: {
      email
    }
  })
}

exports.findUserById = id => {
  return db.User.findUnique({
    where: {
      id
    }
  })
}

exports.registerByEmail = user => {
  user.password = bcrypt.hashSync(user.password, 12)
  return db.User.create({
    data: user
  })
}
