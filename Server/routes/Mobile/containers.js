const express = require('express')
const router = express.Router()

const containerCtrl = require("../../controllers/Common/container");
const itemCtrl = require("../../controllers/Common/items");

router.get("/listAll", async function (req, res, next) {
  try {
    const container = await containerCtrl.listContainers();

    return res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.get('/:containerId', async (req, res, next) => {
  try {
    if (!req.params.containerId || req.params.containerId === '') {
      return res.status(400).send(res.__('missingContainerId'));
    }
    const container = await containerCtrl.getContainerById(parseInt(req.params.containerId))
    if (!container) {
      return res.status(404).send(res.__('containerNotFound'))
    }
    const count = await itemCtrl.getAvailableItemsCount(parseInt(req.params.containerId))

    return res.status(200).json({...container, count})
  } catch (err) {
    next(err);
  }
})

router.get('/:containerId/articleslist', async (req, res) => {
  try {
    const containerId = req.params.containerId;
    if (!containerId || containerId === '') {
      return res.status(400).send(res.__('missingContainerId'))
    }
    const articleName = req.query.articleName || '';
    const categoryId = req.query.categoryId === 'null' ? null : req.query.categoryId;
    const isAvailable = req.query.isAvailable === 'false' ? false : true;
    const isAscending = req.query.isAscending === 'false' ? false : true;
    const sortBy = req.query.sortBy || 'price';
    const min = parseFloat(req.query.min) || 0;
    const max = parseFloat(req.query.max) || 1000000;
    const items = await containerCtrl.getItemsWithFilters(
      parseInt(containerId),
      articleName,
      isAscending,
      isAvailable,
      categoryId,
      sortBy,
      min,
      max
    );
    return res.status(200).json(items);
  } catch (err) {
    return res.status(400).send(res.__('errorRetrievingItems'))
  }
});

module.exports = router
