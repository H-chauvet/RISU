'use strict'

const express = require('express')
const passport = require('passport')
const auth = require('./passport/strategy_options')
const auth_token = require('./passport/bearer_token')

const database = require('./database_init')
const bodyParser = require('body-parser')
const session = require('express-session')
const jwt = require('jwt-simple')
const utils = require('./utils')
const axios = require('axios')
require('dotenv').config({ path: '../application.env' })

const app = express()

passport.serializeUser((user, done) => {
  done(null, user.id)
})

passport.deserializeUser((id, done) => {
  done(null, { id: id })
})

app.use(bodyParser.json())
app.use(session({ secret: 'SECRET', resave: false, saveUninitialized: false }))
app.use(passport.initialize())
app.use(passport.session())

const PORT = 8080
const HOST = '0.0.0.0'

/**
 * Set the header protocol to authorize Web connection
 * @memberof route
 */
app.use(function (req, res, next) {
  // Allow access request from any computers
  res.header('Access-Control-Allow-Origin', '*')
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  )
  res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE,PATCH')
  res.header('Access-Control-Allow-Credentials', true)
  if ('OPTIONS' == req.method) {
    res.sendStatus(200)
  } else {
    next()
  }
})

app.get('/', (req, res) => {
  res.send('Hello World')
})

/**
 * Post request to signup a new user in the database.
 * body.email -> User mail
 * body.password -> User password
 * An e-mail is now send to the user.
 */
app.post('/api/signup', (req, res, next) => {
  passport.authenticate(
    'signup',
    { session: false },
    async (err, user, info) => {
      if (err) throw new Error(err)
      if (user == false) return res.json(info)
      const token = utils.generateToken(user.id)
      try {
        const decoded = jwt.decode(token, process.env.JWT_SECRET)
        const user = await database.prisma.User.findUnique({
          where: { id: decoded.id }
        })
        await database.prisma.User.update({
          where: { id: decoded.id },
          data: { mailVerification: true }
        })
      } catch (err) {
        console.error(err.message)
        res.status(401).send('An error occured.')
      }
      return res.status(201).json({
        status: 'success',
        statusCode: res.statusCode
      })
    }
  )(req, res, next)
})

app.post('/api/login', (req, res, next) => {
  passport.authenticate('login', { session: false }, (err, user, info) => {
    if (err) throw new Error(err)
    if (user == false) return res.json(info)
    const token = utils.generateToken(user.id)
    return res.status(201).json({
      status: 'success',
      data: { message: 'Welcome back.', user, token },
      statusCode: res.statusCode
    })
  })(req, res, next)
})

app.get('/api/dev/user/listall', async (req, res) => {
  try {
    const users = await database.prisma.User.findMany()
    return res.json(users)
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

app.listen(PORT, HOST, () => {
  console.log(`Server running...`)
})
