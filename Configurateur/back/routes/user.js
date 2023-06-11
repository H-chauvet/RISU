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
      throw new Error("Email don't exists")
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

module.exports = router
