const express = require('express')
const router = express.Router()
const feedbacksCtrl = require('../../controllers/Web/feedbacks')

router.post("/create", async function (req, res, next) {
  try {
    const { firstName, lastName, email, message, mark } = req.body;
    if (!firstName || !lastName || !email || !message || !mark) {
      res.status(400);
      throw new Error("Some informations are missing");
    }
    const msg = await feedbacksCtrl.registerFeedbacks({
      lastName,
      firstName,
      email,
      message,
      mark,
    });
    res.status(200).json("Avis enregistré !");
  } catch (err) {
    next(err);
  }
});

router.get("/listAll", async function (req, res, next) {
  const mark = parseInt(req.query.mark);

  try {
    const feedbacks = await feedbacksCtrl.getAllFeedbacks(mark);

    res.status(200).json({ feedbacks });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
