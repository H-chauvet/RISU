const express = require('express')
const router = express.Router()

const itemCtrl = require('../../controllers/Common/items')

router.get('/listAll', async (req, res, next) => {
  try {
    const articles = await itemCtrl.getAllItems()
    return res.status(200).json(articles)
  } catch (err) {
    next(err)
    return res.status(400).send(res.__('errorOccured'))
  }
})

router.get('/:articleId', async (req, res) => {
  try {
    const article = await itemCtrl.getItemFromId(parseInt(req.params.articleId))
    if (!article) {
      return res.status(404).send(res.__('articleNotFound'))
    }
    return res.status(200).json(article)
  } catch (err) {
    console.error(err.message)
    return res.status(400).send(res.__('errorOccured'))
  }
})

router.get('/:articleId/similar', async (req, res, next) => {
  try {
    const containerId = req.query.containerId
    if (!containerId) {
      return res.status(404).send(res.__('missingContainerId'))
    }
    const articles = await itemCtrl.getSimilarItems(parseInt(req.params.articleId), parseInt(containerId))
    if (!articles) {
      return res.status(404).send(res.__('articleNotFound'))
    }
    return res.status(200).json(articles)
  } catch (err) {
    next(err)
    return res.status(400).send(res.__('errorOccured'))
  }
});

module.exports = router
