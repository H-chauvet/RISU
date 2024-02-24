const deleteUser = require('./deleteUser')
const login = require('./login')
const register = require('./register')
const confirmRegister = require('./confirmRegister')
const registerConfirmation = require('./registerConfirmation')
const updatePassword = require('./updatePassword')
const forgotPassword = require('./forgotPassword')

module.exports = {
  paths: {
    '/delete': {
      ...deleteUser
    },
    '/login': {
      ...login
    },
    '/register': {
      ...register
    },
    '/confirmed-register': {
      ...confirmRegister
    },
    '/register-confirmation': {
      ...registerConfirmation
    },
    '/update-password': {
      ...updatePassword
    },
    '/forgot-password': {
      ...forgotPassword
    }
  }
}
