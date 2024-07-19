const express = require('express')
const router = express.Router()

const itemCtrl = require('../../controllers/Common/items')

router.get('/listAll', async (req, res, next) => {
  try {
    const articles = await itemCtrl.getAllItems()
    return res.status(200).json(articles)
  } catch (err) {
    next(err)
    return res.status(400).json('An error occurred')
  }
})

router.get('/:articleId', async (req, res) => {
  try {
    const article = await itemCtrl.getItemFromId(parseInt(req.params.articleId))
    if (!article) {
      return res.status(404).send("article not found")
    }
    return res.status(200).json(article)
  } catch (err) {
    console.error(err.message)
    return res.status(400).send('An error occurred')
  }
})

router.get('/:articleId/similar', async (req, res, next) => {
  try {
    const containerId = req.query.containerId
    if (!containerId) {
      return res.status(404).send("containerId is required")
    }
    const articles = await itemCtrl.getSimilarItems(parseInt(req.params.articleId), parseInt(containerId))
    if (!articles) {
      return res.status(404).send("article not found")
    }
    return res.status(200).json(articles)
  } catch (err) {
    next(err)
    return res.status(400).json('An error occurred')
  }
});

module.exports = router
