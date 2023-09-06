const jwt = require('jsonwebtoken')
const crypto = require('crypto')

function generateAccessToken (user) {
  return jwt.sign({ userId: user.id }, process.env.JWT_ACCESS_SECRET, {
    expiresIn: '15m'
  })
}

function hashToken (token) {
  return crypto.createHash('sha512').update(token).digest('hex')
}

function verifyToken (token) {
  return jwt.verify(token, process.env.JWT_ACCESS_SECRET)
}

module.exports = {
  generateAccessToken,
  hashToken,
  verifyToken
}
