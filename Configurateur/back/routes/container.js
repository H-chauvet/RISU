const express = require('express')
const router = express.Router()

const containerCtrl = require('../controllers/container')

router.get('/get', async function (req, res, next) {
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

router.delete('/delete', async function (req, res, next) {
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

router.post('/create', async function (req, res, next) {
  try {
    const { container } = req.body

    if (!container) {
      res.status(400)
      throw new Error('userId and name are required')
    }
    await containerCtrl.createContainer({ container })
    res.status(200).json('container created')
  } catch (err) {
    next(err)
  }
})

router.put('/update', async function (req, res, next) {
  try {
    const { id } = req.body

    if (!id) {
      res.status(400)
      throw new Error('id and name are required')
    }
    await containerCtrl.updateContainer({ id })
    res.status(200).json('container updated')
  } catch (err) {
    next(err)
  }
})

module.exports = router
