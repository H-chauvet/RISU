const express = require('express')
const router = express.Router()

const containerCtrl = require("../../controllers/Common/container");
const mobileContainerCtrl = require("../../controllers/Mobile/container");
const itemCtrl = require("../../controllers/Common/items");
const passport = require('passport')

router.get("/listAll", async function (req, res, next) {
  try {
    const container = await mobileContainerCtrl.listContainers();

    return res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.get('/:containerId', async (req, res, next) => {
  try {
    if (!req.params.containerId || req.params.containerId === '') {
      return res.status(400).message("id is required");
    }
    const container = await containerCtrl.getContainerById(parseInt(req.params.containerId))
    if (!container) {
      return res.status(401).json("container not found")
    }
    const count = await itemCtrl.getAvailableItemsCount(parseInt(req.params.containerId))

    return res.status(200).json({...container, count})
  } catch (err) {
    next(err);
  }
})

router.get('/:containerId/articleslist/', async (req, res) => {
  try {
    const containerId = req.params.containerId;
    if (!containerId || containerId === '') {
      return res.status(401).json({ message: 'Missing containerId' });
    }
    const articleName = req.query.articleName || '';
    const categoryId = req.query.categoryId === 'null' ? null : req.query.categoryId;
    const isAvailable = req.query.isAvailable || true;
    const isAscending = req.query.isAscending || true;
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
    return res.status(401).send('An error occurred while getting the items');
  }
});

module.exports = router
