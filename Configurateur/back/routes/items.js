const express = require('express')
const router = express.Router()

const itemCtrl = require('../controllers/items')
const jwtMiddleware = require('../middleware/jwt')

router.post('/delete', async function (req, res, next) {
  try {
    const { id } = req.body

    if (!id) {
      res.status(400)
      throw new Error('userId is required')
    }
    await itemCtrl.deleteItem(id)
    res.status(200).json('items deleted')
  } catch (err) {
    next(err)
  }
})

router.post('/create', async (req, res) => {
  try {
    const { id, name, available, price, containerId } = req.body
    const item = await itemCtrl.createItem(
      {
          id,
          name,
          available,
          price,
          containerId,
      }
    )
    res.status(200).json(item)
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

router.put("/update", async function (req, res, next) {
  try {
    const {
      id,
      name,
      available,
      createdAt,
      containerId,
      price,
      image,
      description,
    } = req.body;

    if (!id) {
      res.status(400);
      throw new Error("id and name are required");
    }

    const item = await containerCtrl.updateItem(id, {
      name,
      available,
      createdAt,
      containerId,
      price,
      image,
      description,
    });
    res.status(200).json(item);
  } catch (err) {
    next(err);
  }
});

router.get('/listAll', async function(req, res, next) {
  try {
    const containerId = req.query.containerId;
    const item = await itemCtrl.getAllItem(parseInt(containerId));

    res.status(200).json({ item });
  } catch (err) {
    next(err);
  }
})

module.exports = router
