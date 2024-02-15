const express = require('express')

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const opinionCtrl = require("../../controllers/Mobile/opinion")

router.get('/',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    var opinions = []
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }

      const note = req.query.note
      if (note != null  && (note < '0' || note > '5')) {
        return res.status(401).json({ message: 'Missing note' })
      }
      opinions = await opinionCtrl.getOpinions(note)

      var result = []
      for (var i = 0; i < opinions.length; i++) {
        const user = await userCtrl.findUserById(opinions[i].userId)
        result.push({
          firstName: user.firstName ?? "Utilisateur",
          lastName: user.lastName ?? "Supprimé",
          comment: opinions[i].comment,
          note: opinions[i].note
        })
      }

      return res.status(201).json({ result })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.post('/',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.body.comment || req.body.comment === '') {
        return res.status(401).json({ message: 'Missing comment' })
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(401).json({ message: 'Missing note' })
      }

      await opinionCtrl.createOpinion(user.id, req.body.note, req.body.comment)

      return res.status(201).json({ message: 'opinion saved' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

module.exports = router