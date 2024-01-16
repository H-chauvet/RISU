const express = require("express");
const router = express.Router();
const paymentCtrl = require("../controllers/payment");

router.post("/card-pay", async function (req, res, next) {
  const { containerId, paymentMethodId, currency, useStripeSdk, amount } =
    req.body;

  try {
    res.send(
      await paymentCtrl.makePayments({
        paymentMethodId,
        currency,
        useStripeSdk,
        amount,
        containerId,
      })
    );
  } catch (e) {
    res.status(500).send({
      error: e.message,
    });
  }
});

module.exports = router;
