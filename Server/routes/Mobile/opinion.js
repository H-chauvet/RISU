const express = require('express')

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const opinionCtrl = require("../../controllers/Mobile/opinion")
const itemsCtrl = require("../../controllers/Common/items")
const jwtMiddleware = require('../../middleware/Mobile/jwt')
const languageMiddleware = require('../../middleware/language')

router.get('/', async (req, res) => {
  var opinions = []
  try {
    if (req.query.itemId == null) {
      return res.status(400).send(res.__('missingItemId'))
    }

    var note = req.query.note
    if (note != null) {
      if (note < 0 || note > 5) {
        return res.status(400).send(res.__('invalidRating'))
      }
    }
    opinions = await opinionCtrl.getOpinions(parseInt(req.query.itemId), note)

    return res.status(200).json({ opinions })
  } catch (err) {
    console.error(err.message)
    return res.status(400).send(res.__('errorOccured'))
  }
})

router.post('/', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__('invalidToken'))
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send(res.__('userNotFound'))
      }
      languageMiddleware.setServerLanguage(req, user)
      if (!req.body.comment || req.body.comment === '') {
        return res.status(400).send(res.__('missingComment'))
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(400).send(res.__('missingRating'))
      }
      if (req.query.itemId == null) {
        return res.status(400).send(res.__('missingItemId'))
      }
      const item = await itemsCtrl.getItemFromId(parseInt(req.query.itemId))
      if (item == null) {
        return res.status(404).send(res.__('itemNotFound'))
      }

      await opinionCtrl.createOpinion(item.id, user.id, req.body.note, req.body.comment)

      return res.status(201).send(res.__('reviewSaved'))
    } catch (err) {
      console.error(err.message)
      return res.status(400).send(res.__('errorOccured'))
    }
  }
)

router.delete('/:opinionId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__('invalidToken'))
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send(res.__('userNotFound'))
      }
      languageMiddleware.setServerLanguage(req, user)
      const opinionId = req.params.opinionId
      if (opinionId == null) {
        return res.status(400).send(res.__('missingReviewId'))
      }
      const opinion = await opinionCtrl.getOpinionFromId(opinionId)
      if (!opinion) {
        return res.status(404).send(res.__('reviewNotFound'))
      }
      if (opinion.userId != user.id) {
        return res.status(403).send(res.__('unauthorized'))
      }
      await opinionCtrl.deleteOpinion(opinionId)

      return res.status(200).send(res.__('reviewDeleted'))
    } catch (err) {
      console.error(err.message)
      return res.status(400).ssend(res.__('errorOccured'))
    }
  }
)

router.put('/:opinionId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__('invalidToken'))
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send(res.__('userNotFound'))
      }
      languageMiddleware.setServerLanguage(req, user)
      const opinionId = req.params.opinionId
      if (opinionId == null) {
        return res.status(400).send(res.__('missingReviewId'))
      }
      const opinion = await opinionCtrl.getOpinionFromId(opinionId)
      if (!opinion) {
        return res.status(404).send(res.__('reviewNotFound'))
      }
      if (opinion.userId != user.id) {
        return res.status(403).send(res.__('unauthorized'))
      }
      if (!req.body.comment || req.body.comment === '') {
        return res.status(400).send(res.__('missingComment'))
      }
      if (!req.body.note || req.body.note === '') {
        return res.status(400).send(res.__('missingRating'))
      }
      await opinionCtrl.updateOpinion(opinionId, req.body.note, req.body.comment)

      return res.status(201).send(res.__('reviewUpdated'))
    } catch (err) {
      console.error(err.message)
      return res.status(400).send(res.__('errorOccured'))
    }
  }
)

module.exports = router
