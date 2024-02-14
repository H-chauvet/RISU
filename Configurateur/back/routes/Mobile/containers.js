const express = require('express')
const router = express.Router()

const containerCtrl = require("../../controllers/Common/container");
const itemCtrl = require("../../controllers/Common/items")

router.get("/listAll", async function (req, res, next) {
  try {
    const container = await containerCtrl.getAllContainers();

    res.status(200).json({ container });
  } catch (err) {
    next(err);
  }
});

router.get('/:containerId', async (req, res, next) => {
  // try {
  //   jwtMiddleware.verifyToken(req.headers.authorization);
  // } catch (err) {
  //   res.status(401);
  //   throw new Error("Unauthorized");
  // }
  try {
    if (!req.params.containerId || req.params.containerId === '') {
      res.status(400);
      throw new Error("id is required");
    }
    const container = await containerCtrl.getContainer(req.params.containerId)
    if (!container) {
      return res.status(401).json("container not found")
    }
    const count = await itemCtrl.getAvailableItemsCount(req.params.containerId)

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
    const container = await containerCtrl.getItemsFromContainer(req.params.containerId)
    if (!container) {
      return res.status(401).json("itemList not found")
    } else if (!container.items || container.items.length === 0) {
      return res.status(204).json({ message: 'Container doesn\'t have items' })
    }
    return res.status(200).json(container.items)
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('An error occurred')
  }
})

module.exports = router