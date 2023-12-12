const express = require('express')
const router = express.Router()

const userCtrl = require('../controllers/user')
const jwtMiddleware = require('../middleware/jwt')
const generator = require('generate-password')

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
});

router.post('/google-login', async function (req, res, next) {
  try {
    const { email } = req.body
    if (!email) {
      res.status(400)
      throw new Error('Email and password are required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    let user = null
    if (!existingUser) {
      const password = generator.generate({
        length: 8,
        numbers: true,
        symbols: true,
        uppercase: false,
        excludeSimilarCharacters: true,
        strict: true
      })
      user = await userCtrl.registerByEmail({ email, password: password })
    }

    const accessToken = jwtMiddleware.generateAccessToken(user)

    res.json({
      accessToken
    })
  } catch (err) {
    next(err)
  }
});

router.post('/register', async function (req, res, next) {
  try {
    const { firstName, lastName, company, email, password } = req.body
    if (!email || !password) {
      res.status(400)
      throw new Error('Email and password are required')
    }
    console.log(email);

    const existingUser = await userCtrl.findUserByEmail(email)
    if (existingUser) {
      res.status(400)
      throw new Error('Email already exists')
    }

    const user = await userCtrl.registerByEmail({
      firstName,
      lastName,
      company,
      email,
      password
    })
    const accessToken = jwtMiddleware.generateAccessToken(user)

    res.status(200).json({
      accessToken
    })
  } catch (err) {
    next(err)
  }
});

router.post('/forgot-password', async function (req, res, next) {
  try {
    const { email } = req.body

    if (!email) {
      res.status(400)
      throw new Error('Email is required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    if (!existingUser) {
      res.status(400)
      throw new Error('Invalid email')
    }

    userCtrl.forgotPassword(email)
    res.json('ok')
  } catch (err) {
    next(err)
  }
});

router.post('/update-password', async function (req, res, next) {
  try {
    const { uuid, password } = req.body

    if (!uuid || !password) {
      res.status(400)
      throw new Error('Email and password are required')
    }

    const existingUser = await userCtrl.findUserByUuid(uuid)
    if (!existingUser) {
      res.status(401)
      throw new Error("Account don't exist")
    }

    const ret = await userCtrl.updatePassword({ uuid, password })
    res.json(ret)
  } catch (err) {
    next(err)
  }
});

router.post('/register-confirmation', async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization)
  } catch (err) {
    res.status(401)
    throw new Error('Unauthorized')
  }
  try {
    const { email } = req.body

    if (!email) {
      res.status(400)
      throw new Error('Email is required')
    }

    const existingUser = await userCtrl.findUserByEmail(email)
    if (!existingUser) {
      res.status(400)
      throw new Error('Invalid email')
    }

    userCtrl.registerConfirmation(email)
    res.json('ok')
  } catch (err) {
    next(err)
  }
});

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
});

router.post('/delete', async function (req, res, next) {
  const { email } = req.body

  try {
    await userCtrl.deleteUser(email)
    res.json('ok').status(200)
  } catch (err) {
    res.json('ok').status(200)
  }
});

router.get('/privacy', async function (req, res, next) {
  try {
    const privacyDetails =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'

    res.send(privacyDetails)
  } catch (err) {
    next(err)
  }
});

router.get('/listAll', async function(req, res, next) {
  try {
    const user = await userCtrl.getAllUsers();

    res.status(200).json({ user });
  } catch (err) {
    next(err);
  }
});

router.get('/user-details/:email', async (req, res) => {
  const email = req.params.email;

  try {
    const userDetails = await userController.findUserDetailsByEmail(email);
    res.json(userDetails);
  } catch (error) {
    console.error('Error retrieving user details:', error);
    res.status(500).json({ error: 'Failed to retrieve user details' });
  }
});

module.exports = router
