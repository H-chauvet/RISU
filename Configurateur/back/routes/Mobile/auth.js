const express = require('express')

const router = express.Router()

const passport = require('passport')
const jwt = require('jsonwebtoken')
const userCtrl = require('../../controllers/Mobile/user')
const authCtrl = require('../../controllers/Mobile/auth')
const jwtMiddleware = require('../../middleware/Mobile/jwt')


router.post('/signup', (req, res, next) => {
  passport.authenticate(
    'signup',
    { session: false },
    async (err, user, info) => {
      if (err)
        throw new Error(err)
      if (user === false) {
        console.log(info)
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

router.post('/login', (req, res, next) => {
  passport.authenticate(
    'login',
    { session: false },
    (err, user, info) => {
      if (err)
        throw new Error(err)
      if (user == false)
        return res.status(401).json(info)

      const token = jwtMiddleware.generateToken(user.id)
      return res.status(201).json({ user : user, token : token })
    }
  )(req, res, next)
})

router.get('/mailVerification', async (req, res) => {
  const token = req.query.token
  try {
    const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
    const user = await userCtrl.findUserById(decoded.id)
    await userCtrl.verifyEmail(user.id)
    return res.status(200).send(
      'Email now successfully verified !\nYou can go back to login page.'
      )
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('No matching user found.')
  }
})

module.exports = router
