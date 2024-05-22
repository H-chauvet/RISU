const express = require('express')

const router = express.Router()

const passport = require('passport')
const jwt = require('jsonwebtoken')
const userCtrl = require('../../controllers/Mobile/user')
const authCtrl = require('../../controllers/Mobile/auth')
const jwtMiddleware = require('../../middleware/Mobile/jwt')
const crypto = require('../../crypto/crypto')


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
        return res.status(401).send('An error occurred.')
      }
      return res.status(201).send('User created')
    },
  )(req, res, next)
})

router.post('/login', jwtMiddleware.refreshTokenMiddleware, async (req, res, next) => {
  passport.authenticate(
    'login',
    { session: false },
    async (err, user, info) =>  {
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

      return res.status(201).json({ user : user, token : token })
    }
  )(req, res, next)
})

router.post('/login/refreshToken', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const refreshToken = req.body.refreshToken;
  if (!refreshToken || refreshToken == '') {
    return res.status(401).send('No refresh token provided.')
  }
  const user = await userCtrl.findUserByRefreshToken(refreshToken)
  if (!user) {
    return res.status(401).send('No matching user found.')
  }
  const token = jwtMiddleware.generateToken(user.id)
  return res.status(201).json({ user : user, token : token })
})

router.get('/mailVerification', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const token = req.query.token
  try {
    const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
    const user = await userCtrl.findUserById(decoded.id)
    await authCtrl.verifyEmail(user.id)
    return res.status(200).send(
      'Email now successfully verified !\nYou can go back to login page.'
      )
  } catch (err) {
    return res.status(401).send('No matching user found.')
  }
})

router.get('/:email/newEmailVerification', jwtMiddleware.refreshTokenMiddleware, async (req, res) => {
  const token = req.query.token
  const email = req.params.email
  decryptedEmail = crypto.decrypt(email)
  try {
    const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
    var user = await userCtrl.findUserById(decoded.id)
    user = await userCtrl.updateEmail(decoded.id, decryptedEmail);
    return res.status(200).send(
      'New email now successfully verified !\nYou can go back to login page.'
      )
  } catch (err) {
    return res.status(401).send('No matching user found.')
  }
})

module.exports = router
