const express = require("express");
const router = express.Router();

const userCtrl = require("../../controllers/Mobile/user");
const jwtMiddleware = require("../../middleware/Mobile/jwt");
const passport = require("passport")

const jwt = require('jsonwebtoken')

router.post('/signup', (req, res, next) => {
    passport.authenticate(
        'signup',
        { session: false },
        async (err, user, info) => {
            if (err)
                throw new Error(err)
            if (user == false) {
                console.log(info);
                return res.status(401).json(info)
            }
            const token = jwtMiddleware.generateToken(user.id);
            try {
                const decoded = jwt.decode(token, process.env.JWT_ACCESS_SECRET)
                const user = await userCtrl.findUserById(decoded.id);
                userCtrl.sendAccountConfirmationEmail(user.email, token);
            } catch (err) {
                console.error(err.message)
                return res.status(401).send('An error occurred.')
            }
            return res.status(201).send('User created')
        }
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
    return res.status(201).json({ user: user, token: token })
    })(req, res, next)
  })

router.get('/listAll', async (req, res) => {
    try {
      const user = await userCtrl.getAllUsers();
      return res.status(200).json({ user });
    } catch (err) {
      console.log(err)
      return res.status(400).json('An error occured.')
    }
  })

module.exports = router;