const express = require('express')
const router = express.Router()

const containerCtrl = require("../../controllers/Common/container");
const itemCtrl = require("../../controllers/Common/items");
const passport = require('passport')

router.get("/listAll", async function (req, res, next) {
  try {
    const container = await containerCtrl.getAllContainers();

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
    if (!req.params.containerId || req.params.containerId === '') {
      return res.status(401).json({ message: 'Missing containerId' })
    }
    const container = await containerCtrl.getItemsFromContainer(parseInt(req.params.containerId))
    if (!container) {
      return res.status(401).json("itemList not found")
    } else if (!container.items || container.items.length === 0) {
      return res.status(204).json({ message: 'Container doesn\'t have items' })
    }
    console.log(container.items)
    return res.status(200).json(container.items)
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('An error occurred')
  }
})

module.exports = router
