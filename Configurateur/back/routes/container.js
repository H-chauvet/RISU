const express = require('express')
const router = express.Router()

const containerCtrl = require('../controllers/container')
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
    const container = await containerCtrl.getContainer(parseInt(id))
    res.status(200).json(container)
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
    await containerCtrl.deleteContainer(id)
    res.status(200).json('container deleted')
  } catch (err) {
    next(err)
  }
})

router.post('/create-ctn', async (req, res, next) => {
  try {
    const { containerMapping } = req.body
    const container = await containerCtrl.createContainer2(
      { containerMapping,
    })
    res.status(200).json('container created')
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
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
    const { price, containerMapping } = req.body

    if (!price || !containerMapping) {
      res.status(400)
      throw new Error('Container object are required')
    }

    await containerCtrl.createContainer({
      price,
      containerMapping
    })
    res.status(200).json('container created')
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
    const { id, price, containerMapping } = req.body

    if (!id) {
      res.status(400)
      throw new Error('id and name are required')
    }
    await containerCtrl.updateContainer(id, { price, containerMapping })
    res.status(200).json('container updated')
  } catch (err) {
    next(err)
  }
})

router.post('/create-ctn', async (req, res) => {
  try {
    const { id, price, width, height  } = req.body
    const container = await containerCtrl.createContainer2(
      {
          price,
          width,
          height
      }
    )
    res.status(200).json(container)
  } catch (err) {
    console.log(err)
    return res.status(400).json('An error occured.')
  }
})

router.get('/listAll', async function(req, res, next) {
  try {
    const user = await containerCtrl.getAllContainers();

    res.status(200).json({ user });
  } catch (err) {
    next(err);
  }
})

module.exports = router
