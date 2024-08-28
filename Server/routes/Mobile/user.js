const express = require('express')

const router = express.Router()

const passport = require('passport')
const userCtrl = require('../../controllers/Mobile/user')
const authCtrl = require('../../controllers/Mobile/auth')
const cleanCtrl = require('../../controllers/Mobile/cleandata')
const bcrypt = require('bcrypt')
const jwtMiddleware = require('../../middleware/Mobile/jwt')

router.get('/listAll', async (req, res, next) => {
  try {
    const user = await userCtrl.getAllUsers()
    return res.status(200).json({ user })
  } catch (err) {
    next(err)
    return res.status(400).json('An error occured.')
  }
})

router.put('/password', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found');
      }
      const currentPassword = req.body.currentPassword
      if (!currentPassword || currentPassword === '') {
        return res.status(400).send('Missing currentPassword')
      }
      const newPassword = req.body.newPassword
      if (!newPassword || newPassword === '') {
        return res.status(400).send('Missing newPassword')
      }
      const isMatch = await bcrypt.compare(currentPassword, user.password)
      if (!isMatch) {
        return res.status(401).send('Incorrect Current Password')
      }
      var updatedUser = await userCtrl.setNewUserPassword(user, newPassword)
      return res.status(200).json({ updatedUser });
    } catch (err) {
      console.error(err.message)
      return res.status(500).send('An error occurred')
    }
  }
)

router.post('/password/reset', async (req, res) => {
  const { email } = req.body
  if (!email || email === '') {
    return res.status(400).send('Missing email')
  }

  try {
    user = await userCtrl.findUserByEmail(email)
    if (!user) {
      return res.status(404).send('User not found')
    }
    resetToken = jwtMiddleware.generateResetToken(user)
    resetToken = resetToken.substring(0, 64)
    user = await userCtrl.updateUserResetToken(user.id, resetToken)
    await userCtrl.sendResetPasswordEmail(user.email, resetToken)
    user = await userCtrl.removeUserResetToken(user.id)

    return res.status(200).send('Reset password email sent')
  } catch (error) {
    console.error('Failed to reset password:', error)
    return res.status(500).send('Failed to reset password')
  }
})

router.get('/:userId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send('Unauthorized');
      }
      const user = await userCtrl.findUserById(req.params.userId)
      if (!user) {
        return res.status(404).send('User not found');
      }

      return res.status(200).json({ user });
    } catch (err) {
      console.error(err.message)
      return res.status(500).send('An error occurred.')
    }
  }
)

router.put('/', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }
      const updatedUser = await userCtrl.updateUserInfo(user, req.body)
      return res.status(200).json({ updatedUser });
    } catch (error) {
      console.error('Failed to update notifications: ', error)
      return res.status(500).send('Failed to update notifications.')
    }
  }
)

router.put('/newEmail', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send('User not found');
      }
      if (!req.body.newEmail || req.body.newEmail === '') {
        return res.status(400).send('Missing new email');
      }
      const updatedUser = await userCtrl.updateNewEmail(user);
      const token = req.headers.authorization.split(' ')[1];
      authCtrl.sendConfirmationNewEmail(req.body.newEmail, token);
      return res.status(200).json({ updatedUser });
    } catch (error) {
      console.error('Failed to update email: ', error);
      return res.status(500).send('Fail updating new email');
    }
  }
)

router.delete('/:userId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
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
      await cleanCtrl.cleanUserData(user.id, user.notificationsId)
      await userCtrl.deleteUser(user.id)
      return res.status(200).send('User deleted')
    } catch (error) {
      console.error('Failed to delete account: ', error)
      return res.status(500).send('Failed to delete the user')
    }
  }
)

module.exports = router;
