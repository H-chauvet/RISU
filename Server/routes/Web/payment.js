const express = require("express");
const router = express.Router();
const paymentCtrl = require("../../controllers/Web/payment");

router.post("/card-pay", async function (req, res, next) {
  const { containerId, paymentMethodId, currency, useStripeSdk, amount } =
    req.body;

  try {
    res.send(
      await paymentCtrl.makePayments(res, {
        paymentMethodId,
        currency,
        useStripeSdk,
        amount,
        containerId,
      })
    );
  } catch (e) {
    res.status(500).send(e.message);
  }
});

module.exports = router;
