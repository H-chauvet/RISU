const mobileSignUp = require('./Mobile/auth/signup')

module.exports = {
    paths: {
        '/api/mobile/auth/signup': {
        ...mobileSignUp
        }
    }
}