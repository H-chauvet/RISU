const express = require('express')

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const opinionCtrl = require("../../controllers/Mobile/opinion")
const itemsCtrl = require("../../controllers/Common/items")
const jwtMiddleware = require('../../middleware/Mobile/jwt')

router.get('/', async (req, res) => {
  var opinions = []
  try {
    if (req.query.itemId == null) {
      return res.status(400).send('Missing itemId')
    }

    var note = req.query.note
    if (note != null) {
      if (note < 0 || note > 5) {
        return res.status(400).send('Invalid note')
      }
    }
    opinions = await opinionCtrl.getOpinions(parseInt(req.query.itemId), note)

    return res.status(200).json({ opinions })
  } catch (err) {
    console.error(err.message)
    return res.status(400).send('An error occurred')
  }
})

router.post('/', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found')
      }
      if (!req.body.comment || req.body.comment === '') {
        return res.status(400).send('Missing comment')
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(400).send('Missing note')
      }
      if (req.query.itemId == null) {
        return res.status(400).send('Missing itemId')
      }
      const item = await itemsCtrl.getItemFromId(parseInt(req.query.itemId))
      if (item == null) {
        return res.status(404).send('item not found')
      }

      await opinionCtrl.createOpinion(item.id, user.id, req.body.note, req.body.comment)

      return res.status(201).send('opinion saved')
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('An error occurred')
    }
  }
)

router.delete('/:opinionId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send({ message: 'User not found' })
      }
      const opinionId = req.params.opinionId
      if (opinionId == null) {
        return res.status(400).send('Missing opinionId')
      }
      const opinion = await opinionCtrl.getOpinionFromId(opinionId)
      if (!opinion) {
        return res.status(404).send('Opinion not found')
      }
      if (opinion.userId != user.id) {
        return res.status(400).send('Unauthorized')
      }
      await opinionCtrl.deleteOpinion(opinionId)

      return res.status(201).send('opinion deleted')
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('An error occurred')
    }
  }
)

router.put('/:opinionId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found')
      }
      const opinionId = req.params.opinionId
      if (opinionId == null) {
        return res.status(400).send('Missing opinionId')
      }
      const opinion = await opinionCtrl.getOpinionFromId(opinionId)
      if (!opinion) {
        return res.status(404).send('Opinion not found')
      }
      if (opinion.userId != user.id) {
        return res.status(403).send('Unauthorized')
      }
      if (!req.body.comment || req.body.comment === '') {
        return res.status(400).send('Missing comment')
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(400).send('Missing note')
      }
      await opinionCtrl.updateOpinion(opinionId, req.body.note, req.body.comment)

      return res.status(201).send('opinion updated')
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('An error occurred')
    }
  }
)

module.exports = router
