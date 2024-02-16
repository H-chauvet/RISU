const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
require('dotenv').config({ path: '../.env' })

/**
 * A classic function to hash password
 * @param {*} password the password to hash
 * @returns hashed password
 */
const hash = async password => {
  const salt = await bcrypt.genSalt(10)
  password = await bcrypt.hash(password, salt)
  return password
}

/**
 * A classic function to compare password with her hashed version
 * @param {*} hash the hashed one
 * @param {*} pass the normal one
 * @returns true or false
 */
const compare = async (hash, pass) => {
  return bcrypt.compare(hash, pass)
}

module.exports = {
  hash,
  compare
}
