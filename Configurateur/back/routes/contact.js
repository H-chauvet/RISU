const express = require('express')
const router = express.Router()
const contactCtrl = require('../controllers/contact')

router.post('/contact', async function (req, res, next) {
  try {
    const { prenom, nom, email, message } = req.body
    if (!email) {
      res.status(400)
      throw new Error('Email is required')
    }
  
    const msg = await contactCtrl.registerMessage({ nom, prenom, email, message })
    res.status(200).json("Message enregistré !")

    } catch (err) {
      next(err)
    }
})

module.exports = router