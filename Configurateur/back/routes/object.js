const express = require('express')
const router = express.Router()

const objectCtrl = require('../controllers/object')
const jwtMiddleware = require('../middleware/jwt')

router.get('/get', async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization)
  } catch (err) {
    res.status(401)
    throw new Error('Unauthorized')
  }
  try {
    const { id } = req.query

    if (!id) {
      res.status(400)
      throw new Error('id is required')
    }
    const object = await objectCtrl.getObject(parseInt(id))
    res.status(200).json(object)
  } catch (err) {
    next(err)
  }
})

router.post('/delete', async function (req, res, next) {
  try {
    const { id } = req.body

    if (!id) {
      res.status(400)
      throw new Error('userId is required')
    }
    await objectCtrl.deleteObject(id)
    res.status(200).json('object deleted')
  } catch (err) {
    next(err)
  }
})

router.post('/create', async function (req, res, next) {
  try {
    console.log(req.headers.authorization)
    jwtMiddleware.verifyToken(req.headers.authorization)
  } catch (err) {
    res.status(401)
    throw new Error('Unauthorized')
  }
  try {
    const { price, objectMapping, width, height } = req.body

    if (!price || !objectMapping || !width || !height) {
      res.status(400)
      throw new Error('Object object are required')
    }

    await objectCtrl.createObject({
      price,
      objectMapping,
      width,
      height
    })
    res.status(200).json('object created')
  } catch (err) {
    next(err)
  }
})

router.put('/update', async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization)
  } catch (err) {
    res.status(401)
    throw new Error('Unauthorized')
  }
  try {
    const { id, price, objectMapping, height, width } = req.body

    if (!id) {
      res.status(400)
      throw new Error('id and name are required')
    }
    await objectCtrl.updateObject(id, { price, objectMapping,height, width })
    res.status(200).json('object updated')
  } catch (err) {
    next(err)
  }
})

router.post('/create-ctn', async (req, res) => {
  try {
    const { id, name, available, price, containerId } = req.body
    const object = await objectCtrl.createObject2(
      {
          id,
          name,
          available,
          price,
          containerId,
      }
    )
    res.status(200).json(object)
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

router.get('/listAll', async function(req, res, next) {
  try {
    const containerId = req.query.containerId;
    const object = await objectCtrl.getAllObject(parseInt(containerId));

    res.status(200).json({ object });
  } catch (err) {
    next(err);
  }
})

module.exports = router
