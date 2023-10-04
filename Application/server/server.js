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
const nodemailer = require('nodemailer')

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
          data: { mailVerification: false }
        })
        sendAccountConfirmationEmail(user.email, token)
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

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false,
  auth: {
    user: process.env.SMTP_EMAIL,
    pass: process.env.SMTP_PASSWORD
  }
})

async function sendResetPasswordEmail (email, newPassword) {
  const mailOptions = {
    from: process.env.SMTP_EMAIL,
    to: email,
    subject: 'Reset Your Password',
    text: `Your new password is: ${newPassword}`
  }

  try {
    const info = await transporter.sendMail(mailOptions)
    console.log('Reset email sent to ' + email + ' (' + info.response + ')')
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}

function generateRandomPassword (length) {
  const characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@m!$%&*?'
  let password = ''
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length)
    password += characters.charAt(randomIndex)
  }
  return password
}

app.post('/api/user/resetPassword', async (req, res) => {
  const { email } = req.body

  try {
    const user = await database.prisma.User.findUnique({ where: { email } })
    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }

    const newPassword = generateRandomPassword(8)

    await database.prisma.User.update({
      where: { id: user.id },
      data: { password: await utils.hash(newPassword) }
    })

    await sendResetPasswordEmail(email, newPassword)

    return res.status(200).json({ message: 'Reset password email sent' })
  } catch (error) {
    console.error('Failed to reset password:', error)
    return res.status(500).json({ message: 'Failed to reset password' })
  }
})

async function sendAccountConfirmationEmail (email, token) {
  const mailOptions = {
    from: process.env.SMTP_EMAIL,
    to: email,
    subject: 'Confirm your account',
    text:
      'Please follow the link to confirm your account: http://localhost:8080/api/mailVerification?token=' +
      token
  }

  try {
    const info = await transporter.sendMail(mailOptions)
    console.log(
      'Confirmation email sent to ' + email + ' (' + info.response + ')'
    )
    console.log(mailOptions.text)
  } catch (error) {
    console.error('Error sending reset password email:', error)
  }
}

app.get('/api/mailVerification', async (req, res) => {
  const token = req.query.token
  try {
    const decoded = jwt.decode(token, process.env.JWT_SECRET)
    const user = await database.prisma.User.findUnique({
      where: { id: decoded.id }
    })
    await database.prisma.User.update({
      where: { id: decoded.id },
      data: { mailVerification: true }
    })
    res.send(
      'Email now successfully verified !\nYou can go back to login page.'
    )
  } catch (err) {
    console.error(err.message)
    res.status(401).send('No matching user found.')
  }
})

async function createFixtures() {
  await database.prisma.user.createMany({
    data: [
      {
        email: 'admin@gmail.com',
        password: await utils.hash('admin'),
        mailVerification: true,
      },
      {
        email: 'user@gmail.com',
        password: await utils.hash('user'),
        mailVerification: true,
      }
    ]
  })
}

app.listen(PORT, HOST, () => {
  console.log(`Server running...`)
  createFixtures();
})
