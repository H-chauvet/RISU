const express = require('express')

const router = express.Router()

const passport = require('passport')
const jwt = require('jsonwebtoken')
const userCtrl = require('../../controllers/Mobile/user')
const authCtrl = require('../../controllers/Mobile/auth')
const jwtMiddleware = require('../../middleware/Mobile/jwt')
const crypto = require('../../crypto/crypto')
const languageMiddleware = require('../../middleware/language')

router.post('/signup', (req, res, next) => {
  passport.authenticate(
    'signup',
    { session: false },
    async (err, user, info) => {
      if (err)
        throw new Error(err)
      if (user === false) {
        return res.status(401).json(info)
      }
      const token = jwtMiddleware.generateToken(user.id)
      try {
        const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
        const decodedUser = await userCtrl.findUserById(decoded.id)
        authCtrl.sendAccountConfirmationEmail(decodedUser.email, token)
      } catch (err) {
        console.error(err.message)
        return res.status(401).send(res.__('errorOccurred'))
      }
      return res.status(201).send(res.__('userCreated'))
    },
  )(req, res, next)
})

router.post('/login', jwtMiddleware.refreshTokenMiddleware, async (req, res, next) => {
  passport.authenticate(
    'login',
    { session: false },
    async (err, user, info) => {
      if (err)
        throw new Error(err)
      if (user == false)
        return res.status(401).json(info)

      const longTerm = req.body.longTerm || false;

      const token = jwtMiddleware.generateToken(user.id, longTerm);

      var refreshToken = '';
      if (longTerm) {
        refreshToken = jwtMiddleware.generateRefreshToken(user.id);
        user = await userCtrl.updateUserRefreshToken(user.id, refreshToken)
      } else {
        user = await userCtrl.removeUserRefreshToken(user.id)
      }

      return res.status(201).json({ user: user, token: token })
    }
  )(req, res, next)
})

router.post('/login/refreshToken', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const refreshToken = req.body.refreshToken;
  if (!refreshToken || refreshToken == '') {
    return res.status(401).send(res.__('missingRefreshToken'))
  }
  const user = await userCtrl.findUserByRefreshToken(refreshToken)
  if (!user) {
    return res.status(404).send(res.__('userNotFound'))
  }
  languageMiddleware.setServerLanguage(req, user)
  const token = jwtMiddleware.generateToken(user.id)
  return res.status(201).json({ user: user, token: token })
})

router.get('/mailVerification', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const token = req.query.token
  try {
    const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
    const user = await userCtrl.findUserById(decoded.id)
    languageMiddleware.setServerLanguage(req, user)
    await authCtrl.verifyEmail(user.id)
    return res.status(200).send(res.__('emailVerified'))
  } catch (err) {
    return res.status(401).send(res.__('userNotFound'))
  }
})

router.get('/:email/newEmailVerification', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const token = req.query.token
  const email = req.params.email
  decryptedEmail = crypto.decrypt(email)
  try {
    const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
    var user = await userCtrl.findUserById(decoded.id)
    languageMiddleware.setServerLanguage(req, user)
    user = await userCtrl.updateEmail(decoded.id, decryptedEmail);
    return res.status(200).send(res.__('emailVerified'))
  } catch (err) {
    return res.status(401).send(res.__('userNotFound'))
  }
})

module.exports = router
