const express = require('express')

const router = express.Router()

const passport = require('passport')
const userCtrl = require('../../controllers/Mobile/user')
const bcrypt = require('bcrypt')

router.get('/listAll', async (req, res) => {
  try {
    const user = await userCtrl.getAllUsers()
    return res.status(200).json({ user })
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

router.put('/password',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }
      const currentPassword = req.body.currentPassword
      if (!currentPassword || currentPassword === '') {
        return res.status(401).json({ message: 'Missing currentPassword' })
      }
      const newPassword = req.body.newPassword
      if (!newPassword || newPassword === '') {
        return res.status(401).json({ message: 'Missing newPassword' })
      }
      const isMatch = await bcrypt.compare(currentPassword, user.password)
      if (!isMatch) {
        return res.status(401).json({ message: 'Incorrect Current Password' })
      }
      var updatedUser = await userCtrl.setNewUserPassword(user, newPassword)
      return res.status(200).json({ updatedUser });
    } catch (err) {
      console.error(err.message)
      return res.status(500).send('An error occurred')
    }
  }
)

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
    await userCtrl.setNewUserPassword(user, clearPassword)
    await userCtrl.sendResetPasswordEmail(email, clearPassword)

    return res.status(200).json({ message: 'Reset password email sent' })
  } catch (error) {
    console.error('Failed to reset password:', error)
    return res.status(500).json({ message: 'Failed to reset password' })
  }
})

router.get('/:userId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send('Unauthorized');
      }
      const user = await userCtrl.findUserById(req.params.userId)

      return res.status(200).json({ user });
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred.')
    }
  }
)

router.put('/',
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
