const express = require('express')
const router = express.Router()
const userCtrl = require('../../controllers/Web/messages');

router.post("/delete", async (req, res, next) => {
  try {
    const { id } = req.body;

    if (!id) {
      return res.status(400).json({ message: "ID is required." });
    }
    const existingMessage = await userCtrl.findById(id);
    if (!existingMessage) {
      return res.status(404).json({ message: "Message not found." });
    }

    await userCtrl.deleteMessageById(id);

    res.status(200).json({ message: "Message successfully deleted!" });
  } catch (err) {
    next(err);
  }
});

router.get("/list", async (req, res, next) => {
  try {
    const messages = await userCtrl.getAllMessages();

    res.status(200).json({ messages });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
