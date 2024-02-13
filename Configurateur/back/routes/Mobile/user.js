const express = require('express')

const router = express.Router()

const passport = require('passport')
const jwt = require('jsonwebtoken')
const userCtrl = require('../../controllers/Mobile/user')
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
        userCtrl.sendAccountConfirmationEmail(decodedUser.email, token)
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
      return res.status(201).json({ user, token })
    }
  )(req, res, next)
})

router.get('/listAll', async (req, res) => {
  try {
    const user = await userCtrl.getAllUsers()
    return res.status(200).json({ user })
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

router.post('/resetPassword', async (req, res) => {
  const { email } = req.body
  if (!email || email === '') {
    return res.status(401).json({ message: 'Missing fields' })
  }

  try {
    const user = await userCtrl.findUserByEmail(email)
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }
    const clearPassword = userCtrl.generateRandomPassword(8)
    await userCtrl.setTemporaryUserPassword(user, clearPassword)
    await userCtrl.sendResetPasswordEmail(email, newPassword)

    return res.status(200).json({ message: 'Reset password email sent' })
  } catch (error) {
    console.error('Failed to reset password:', error)
    return res.status(500).json({ message: 'Failed to reset password' })
  }
})

router.delete('/:userId',
  passport.authenticate(
    'jwt',
    { session: false },
  ),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send('Unauthorized')
      }
      const user = await userCtrl.findUserById(req.params.userId)
      if (!user) {
        return res.status(404).send('User not found')
      }
      await userCtrl.deleteUser(req.params.userId)
      return res.status(200).send('User deleted')
    } catch (error) {
      console.error('Failed to delete account: ', error)
      return res.status(500).json({ message: 'Failed to delete the user:', error })
    }
  }
)

module.exports = router;
