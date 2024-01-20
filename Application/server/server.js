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
require('dotenv').config({ path: '../.env' })
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
      if (user == false) {
        console.log(info);
        return res.status(401).json(info)
      }
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
        console.log('user : ', user);
        sendAccountConfirmationEmail(user.email, token)
      } catch (err) {
        console.error(err.message)
        return res.status(401).send('An error occurred.')
      }
      return res.status(201).send('User created')
    }
  )(req, res, next)
})

app.post('/api/login', (req, res, next) => {
  passport.authenticate('login', { session: false }, (err, user, info) => {
    if (err) throw new Error(err)
    if (user == false) return res.json(info)
    const token = utils.generateToken(user.id)
    return res.status(201).json({ user: user, token: token, message: 'User logged in' })
  })(req, res, next)
})

app.get('/api/dev/user/listall', async (req, res) => {
  try {
    const user = await database.prisma.User.findMany()
    res.status(200).json({ user });
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

async function sendResetPasswordEmail(email, newPassword) {
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

function generateRandomPassword(length) {
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
  if (!email || email === '') {
    return res.status(401).json({ message: 'Missing fields' })
  }

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

app.delete('/api/user/:userId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send('Unauthorized');
      }
      const user = await database.prisma.User.findUnique({ where: { id: req.params.userId } })
      if (!user) {
        return res.status(404).send('User not found');
      }
      await database.prisma.User.delete({ where: { id: req.params.userId } })
      return res.status(200).send('User deleted');
    } catch (error) {
      console.error('Failed to delete account: ', error)
      return res.status(500).json({ message: 'Failed to delete the user:', error })
    }
  }
)

async function sendAccountConfirmationEmail(email, token) {
  const mailOptions = {
    from: process.env.SMTP_EMAIL,
    to: email,
    subject: 'Confirm your account',
    text:
      'Please follow the link to confirm your account: http://20.111.37.124:8080/api/mailVerification?token=' +
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
    return res.status(200).send(
      'Email now successfully verified !\nYou can go back to login page.'
    )
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('No matching user found.')
  }
})

async function createFixtures() {
  try {
    const notification1 = await database.prisma.Notifications.create({
      data: {
        favoriteItemsAvailable: true,
        endOfRenting: true,
        newsOffersRisu: true
      }
    })
    const notification2 = await database.prisma.Notifications.create({
      data: {
        favoriteItemsAvailable: true,
        endOfRenting: true,
        newsOffersRisu: true
      }
    })
    const container = await database.prisma.Containers.create({
      data: {
        localization: 'Nantes',
        owner: 'Risu',
        items: {
          create: [
            { name: 'ballon de volley', price: 3, available: true },
            { name: 'raquette', price: 6, available: false },
            { name: 'ballon de football', price: 16, available: true },
          ]
        }
      }
    })
    const emptyContainer = await database.prisma.Containers.create({
      data: {
        localization: 'Nantes',
        owner: 'Risu',
        items: {
          create: []
        }
      }
    })
    if (!await database.prisma.User.findUnique({ where: { email: 'admin@gmail.com' } }))
      await database.prisma.User.create({
        data: {
          email: 'admin@gmail.com',
          firstName: 'admin',
          lastName: 'admin',
          password: await utils.hash('admin'),
          mailVerification: true,
          notificationsId: notification1.id,
        },
        include: {
          Notifications: true,
        }
      })
    if (!await database.prisma.User.findUnique({ where: { email: 'user@gmail.com' } }))
      await database.prisma.User.create({
        data: {
          email: 'user@gmail.com',
          firstName: 'user',
          lastName: 'user',
          password: await utils.hash('user'),
          mailVerification: true,
          notificationsId: notification2.id,
        },
        include: {
          Notifications: true,
        }
      })
  } catch (err) {
    console.error(err.message)
  }
}

app.post('/api/contact', async (req, res) => {
  const { name, email, message } = req.body
  if (!name || !email || !message) {
    return res.status(401).send('Missing fields.')
  }
  console.log('back-end : ', name, email, message)
  try {
    await database.prisma.Contact.create({
      data: {
        name: name,
        email: email,
        message: message
      }
    })

    // get all contacts and print
    //const contacts = await database.prisma.Contact.findMany()
    //console.log(contacts)

    return res.status(201).json({ message: 'contact saved' })
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('Error while saving contact.')
  }
})

app.get('/api/user/:userId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send('Unauthorized');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.params.userId },
        include: {
          Notifications: true,
        }
      })
      console.log('user : ', user)
      return res.status(200).json({ user });
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred.')
    }
  }
)

app.put('/api/user/notifications',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id },
        include: { Notifications: true }
      })
      if (!user) {
        return res.status(401).send('User not found');
      }
      const updatedUser = await database.prisma.User.update({
        where: { id: user.id },
        data: {
          Notifications: {
            update: {
              favoriteItemsAvailable: req.body.favoriteItemsAvailable ?? user.Notifications.favoriteItemsAvailable,
              endOfRenting: req.body.endOfRenting ?? user.Notifications.endOfRenting,
              newsOffersRisu: req.body.newsOffersRisu ?? user.Notifications.newsOffersRisu
            }
          }
        },
        include: { Notifications: true }
      })
      return res.status(200).json({ updatedUser });
    } catch (error) {
      console.error('Failed to update notifications: ', error)
      return res.status(500).send('Failed to update notifications.')
    }
  }
)

app.put('/api/user',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id },
      })
      if (!user) {
        return res.status(401).send('User not found');
      }
      const updatedUser = await database.prisma.User.update({
        where: { id: user.id },
        data: {
          firstName: req.body.firstName ?? user.firstName,
          lastName: req.body.lastName ?? user.lastName,
          email: req.body.email ?? user.email,
        }
      })
      return res.status(200).json({ updatedUser });
    } catch (error) {
      console.error('Failed to update notifications: ', error)
      return res.status(500).send('Failed to update notifications.')
    }
  }
)

app.put('/api/user/password',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id },
      })
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
      const isMatch = await utils.compare(currentPassword, user.password)
      if (!isMatch) {
        return res.status(401).json({ message: 'Incorrect Password' })
      }
      var updatedUser = await database.prisma.User.update({
        where: { id: user.id },
        data: { password: await utils.hash(newPassword) }
      })
      return res.status(200).json({ updatedUser });
    } catch (err) {
      console.error(err.message)
      return res.status(500).send('An error occurred')
    }
  }
)

app.get('/api/container/listall', async (req, res) => {
    try {
      const containers = await database.prisma.Containers.findMany()
      return res.status(200).json(containers)
    } catch (err) {
      console.log(err)
      return res.status(400).json(err.message)
    }
  }
)

app.get('/api/container/:containerId', async (req, res) => {
    try {
      if (!req.params.containerId || req.params.containerId === '') {
        return res.status(401).json({ message: 'Missing containerId' })
      }
      const container = await database.prisma.Containers.findUnique({
        where: { id: req.params.containerId },
        select: {
          localization: true,
          owner: true,
          _count: {
            select: {   // count the number of items available related to the container
              items: { where: { available: true } }
            }
          }
        },
      })
      if (!container) {
        return res.status(401).json("container not found")
      }
      return res.status(200).json(container)
    } catch (err) {
      console.error(err.message)
      return res.status(401).send(err.message)
    }
  }
)

app.get('/api/container/articleslist/:containerId', async (req, res) => {
    try {
      if (!req.params.containerId || req.params.containerId === '') {
        return res.status(401).json({ message: 'Missing containerId' })
      }
      const container = await database.prisma.Containers.findUnique({
        where: { id: req.params.containerId },
        select: {
          items: {
            select: {
              id: true,
              containerId: true,
              name: true,
              available: true,
              price: true,
            }
          }
        },
      })
      if (!container) {
        return res.status(401).json("itemList not found")
      } else if (!container.items || container.items.length === 0) {
        return res.status(204).json({ message: 'Container doesn\'t have items' })
      }
      return res.status(200).json(container.items)
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

app.get('/api/article/listall', async (req, res) => {
    try {
      const articles = await database.prisma.Items.findMany()
      res.status(200).json(articles)
    } catch (err) {
      console.log(err)
      return res.status(400).json('An error occured.')
    }
  }
)

app.get('/api/article/:articleId', async (req, res) => {
    try {
      const article = await database.prisma.Items.findUnique({
        where: { id: req.params.articleId },
        select: {
          id: true,
          name: true,
          price: true,
          available: true,
          containerId: true
        }
      })
      if (!article) {
        return res.status(401).json("article not found")
      }
      return res.status(200).json(article)
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

app.post('/api/rent/article',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id },
      })
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.body.price || req.body.price < 0) {
        return res.status(401).json({ message: 'Missing price' })
      }
      if (!req.body.itemId || req.body.itemId === '') {
        return res.status(401).json({ message: 'Missing itemId' })
      }
      if (!req.body.duration || req.body.duration < 0) {
        return res.status(401).json({ message: 'Missing duration' })
      }
      const locationPrice = req.body.price * req.body.duration
      //console.log('locationPrice : ', locationPrice);
      await database.prisma.Location.create({
        data: {
          price: locationPrice,
          //itemId: req.body.itemId,
          userId: user.id,
          createdAt: new Date(),
          duration: parseInt(req.body.duration),
        }
      })
      return res.status(201).json({ message: 'location saved' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

// get rental
app.get('/api/rent',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id }
      })
      if (!user) {
        return res.status(404).send('User not found')
      }
      const rentals = await database.prisma.Location.findMany({
        where: { userId: user.id }
      })
      return res.status(201).json({ rentals: rentals })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

app.get('/api/locations', async (req, res) => {
  try {
    const locations = await database.prisma.Location.findMany()
    return res.status(201).json({ locations });
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('An error occurred')
  }
});

app.post('/api/opinion',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id }
      })
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.body.comment || req.body.comment === '') {
        return res.status(401).json({ message: 'Missing comment' })
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(401).json({ message: 'Missing note' })
      }
      // create int note
      await database.prisma.Opinions.create({
        data: {
          userId: user.id,
          date: new Date(),
          note: req.body.note,
          comment: req.body.comment,
        }
      })

      res.status(201).json({ message: 'opinion saved' })
    } catch (err) {
      console.error(err.message)
      res.status(401).send('An error occurred')
    }
  }
)

app.get('/api/opinion',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    var opinions = []
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await database.prisma.User.findUnique({
        where: { id: req.user.id }
      })
      if (!user) {
        return res.status(401).send('User not found');
      }

      const note = req.query.note
      if (note != null) {
        if (!note || note != '0' && note != '1' && note != '2'
          && note != '3' && note != '4' && note != '5') {
          return res.status(401).json({ message: 'Missing note' })
        }
        opinions = await database.prisma.Opinions.findMany({
          where: { note: note }
        })
      } else {
        opinions = await database.prisma.Opinions.findMany()
      }

      var result = []
      // for each opinion, add in result {'user.firstName + lastName', comment, note}
      for (var i = 0; i < opinions.length; i++) {
        const user = await database.prisma.User.findUnique({
          where: { id: opinions[i].userId }
        })
        result.push({
          firstName: user.firstName,
          lastName: user.lastName,
          comment: opinions[i].comment,
          note: opinions[i].note
        })
      }

      res.status(201).json({ result })
    } catch (err) {
      console.error(err.message)
      res.status(401).send('An error occurred')
    }
  }
)

app.listen(PORT, HOST, () => {
  console.log(`Server running...`)
  createFixtures()
})

module.exports = app
