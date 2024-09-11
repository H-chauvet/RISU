const express = require("express");
const router = express.Router();

const itemCtrl = require('../../controllers/Common/items')
const imagesCtrl = require('../../controllers/Common/images')

router.get("/listAll", async (req, res, next) => {
  try {
    const articles = await itemCtrl.getAllItems(res);
    return res.status(200).json(articles);
  } catch (err) {
    next(err)
    return res.status(400).json(res.__("errorOccured"))
  }
})

router.get("/:articleId", async (req, res) => {
  try {
    const article = await itemCtrl.getItemFromId(
      res,
      parseInt(req.params.articleId)
    );
    if (!article) {
      return res.status(404).send(res.__("articleNotFound"));
    }
    const images = await imagesCtrl.getItemImagesUrl(article.id);
    article.imageUrl = images;
    return res.status(200).json(article);
  } catch (err) {
    console.error(err.message);
    return res.status(400).send(res.__("errorOccured"));
  }
});

router.get("/:articleId/similar", async (req, res, next) => {
  try {
    const containerId = req.query.containerId;
    if (!containerId) {
      return res.status(404).send(res.__("missingContainerId"));
    }
    const articles = await itemCtrl.getSimilarItems(
      res,
      parseInt(req.params.articleId),
      parseInt(containerId)
    );
    if (!articles) {
      return res.status(404).send(res.__("articleNotFound"));
    }
    for (const article of articles) {
      const imageUrl = await imagesCtrl.getItemImagesUrl(article.id, 0);
      article.imageUrl = imageUrl[0];
    }
    return res.status(200).json(articles);
  } catch (err) {
    next(err);
    return res.status(400).send(res.__("errorOccured"));
  }
});

module.exports = router;
