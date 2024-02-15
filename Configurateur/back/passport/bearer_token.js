const { Strategy, ExtractJwt } = require('passport-jwt')
const passport = require('passport')
const { db } = require('../../middleware/database')
require('dotenv').config({ path: '../.env' })

/**
 * Strategy options needed by passport
 */
const options = {
  secretOrKey: process.env.JWT_ACCESS_SECRET,
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken()
}

/**
 * Setup a passport strategy option for Bearer Token
 */
passport.use(
  new Strategy(options, async (jwt_payload, done) => {
    try {
      const user = await db.User_Mobile.findUnique({
        where: {
          id: jwt_payload.id
        }
      })
      if (!user.mailVerification) {
        return done(null, null)
      }
      return done(null, user)
    } catch (err) {
      console.error(err.message)
      return done(null, null)
    }
  })
)
