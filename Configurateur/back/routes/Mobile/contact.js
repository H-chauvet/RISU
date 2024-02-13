const express = require('express')

const router = express.Router()

const contactCtrl = require('../../controllers/Mobile/contact')

router.post('/contact', async (req, res) => {
  const { name, email, message } = req.body
  if (!name || !email || !message) {
    return res.status(401).send('Missing fields.')
  }

  try {
    await contactCtrl.createContact(name, email, message)

    return res.status(201).json({ message: 'contact saved' })
  } catch (err) {
    console.error(err.message)
    return res.status(401).send('Error while saving contact.')
  }
})

module.exports = router