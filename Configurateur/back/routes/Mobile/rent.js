const express = require('express')

const router = express.Router()
const passport = require('passport')
const rentCtrl = require("../../controllers/Mobile/rent")
const userCtrl = require("../../controllers/Mobile/user")
const itemCtrl = require("../../controllers/Common/items")

router.post('/article',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(401).send('User not found');
      }
      if (!req.body.itemId || req.body.itemId === '') {
        return res.status(401).json({ message: 'Missing itemId' })
      }

      const item = await itemCtrl.getItemFromId(req.body.itemId)
      if (!item) {
        return res.status(401).send('Item not found');
      }
      if (!req.body.duration || req.body.duration < 0) {
        return res.status(401).json({ message: 'Missing duration' })
      }
      if (!item.available) {
        return res.status(401).send('Item not available');
      }
      const locationPrice = item.price * req.body.duration

      await itemCtrl.updateItem(item.id, { available: false })
      await rentCtrl.rentItem(locationPrice, item.id, user.id, parseInt(req.body.duration))
      return res.status(201).json({ message: 'location saved' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.get('/listAll',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found')
      }
      const rentals = await rentCtrl.getUserRents(user.id)
      return res.status(200).json({ rentals: rentals })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.get('/:rentId',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      if (!req.params.rentId || req.params.rentId == '') {
        return res.status(401).json({ message: 'Missing rentId' })
      }
      const rental = await rentCtrl.getRentFromId(req.params.rentId)
      if (!rental) {
        return res.status(401).send('Location not found')
      }
      if (rental.userId != req.user.id) {
        return res.status(401).send('Location from wrong user')
      }
      return res.status(201).json({ rental: rental })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)

router.post('/:rentId/return',
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token')
      }
      if (!req.params.rentId || req.params.rentId == '') {
        return res.status(401).json({ message: 'Missing rentId' })
      }
      const rent = await rentCtrl.getRentFromId(req.params.rentId)
      if (!rent) {
        return res.status(401).send('Location not found')
      }
      if (rent.userId != req.user.id) {
        return res.status(401).send('Location from wrong user')
      }
      await rentCtrl.returnRent(req.params.rentId)
      return res.status(201).json({ message: 'location returned' })
    } catch (err) {
      console.error(err.message)
      return res.status(401).send('An error occurred')
    }
  }
)


module.exports = router