const express = require("express");
const router = express.Router();
const feedbacksCtrl = require("../../controllers/Web/feedbacks");

router.post("/create", async function (req, res, next) {
  try {
    const { firstName, lastName, email, message, mark } = req.body;
    if (!firstName || !lastName || !email || !message || !mark) {
      return res.status(400).send(res.__("missingParameters"));
    }
    const msg = await feedbacksCtrl.registerFeedbacks(res, {
      lastName,
      firstName,
      email,
      message,
      mark,
    });

    res.status(200).send(res.__("reviewSaved"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/listAll", async function (req, res, next) {
  const mark = parseInt(req.query.mark);

  try {
    const feedbacks = await feedbacksCtrl.getAllFeedbacks(res, mark);

    res.status(200).json({ feedbacks });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
