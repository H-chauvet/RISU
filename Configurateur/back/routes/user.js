const express = require('express')
const router = express.Router()

const userCtrl = require('../controllers/user')
const jwtMiddleware = require('../middleware/jwt')

router.post('/login', async function (req, res, next) {
  try {
    const { email, password } = req.body
    if (!email || !password) {
      res.status(400)
      throw new Error('Email and password are required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    if (!existingUser) {
      res.status(400)
      throw new Error("Email don't exist")
    }

    const user = await userCtrl.loginByEmail({ email, password })
    const accessToken = jwtMiddleware.generateAccessToken(user)

    res.json({
      accessToken
    })
  } catch (err) {
    next(err)
  }
})

router.post('/register', async function (req, res, next) {
  try {
    const { email, password } = req.body
    if (!email || !password) {
      res.status(400)
      throw new Error('Email and password are required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    if (existingUser) {
      res.status(400)
      throw new Error('Email already exists')
    }

    const user = await userCtrl.registerByEmail({ email, password })
    const accessToken = jwtMiddleware.generateAccessToken(user)

    res.json({
      accessToken
    })
  } catch (err) {
    next(err)
  }
})

router.post('/update-password', async function (req, res, next) {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      res.status(400)
      throw new Error('Email and password are required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    if (!existingUser) {
      res.status(400)
      throw new Error("Email don't exist")
    }

    const ret = await userCtrl.updatePassword({ email, password })
    res.json(ret)
  } catch (err) {
    next(err)
  }
})

router.post('/register-confirmation', async function (req, res, next) {
  try {
    const { email } = req.body

    if (!email) {
      res.status(400)
      throw new Error('Email is required')
    }

    userCtrl.registerConfirmation(email)
    res.json('ok')
  } catch (err) {
    next(err)
  }
})

router.post('/confirmed-register', async function (req, res, next) {
  try {
    const { uuid } = req.body

    if (!uuid) {
      res.status(400)
      throw new Error('uuid is required')
    }

    await userCtrl.confirmedRegister(uuid)
    res.json('user confirmed')
  } catch (err) {
    next(err)
  }
})

module.exports = router
