const express = require("express");
const router = express.Router();

const userCtrl = require("../../controllers/Mobile/user");
const jwtMiddleware = require("../../middleware/Mobile/jwt");
const passport = require("passport")

const jwt = require('jsonwebtoken')

router.post('/mobile/signup', (req, res, next) => {
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
module.exports = router;