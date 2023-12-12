const express = require("express");
const router = express.Router();
const Stripe = require("stripe");

const generateResponse = (intent) => {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.client_secret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        error: "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      console.log("Payment received!");
      return { clientSecret: intent.client_secret, status: intent.status };
  }

  return {
    error: "Failed",
  };
};

router.post("/card-pay", async function (req, res, next) {
  const { paymentMethodId, paymentIntentId, currency, useStripeSdk } = req.body;

  const orderAmount = 1000;
  const secret_key = "pranked";

  const stripe = new Stripe(secret_key, {
    apiVersion: "2023-08-16",
    typescript: false,
  });

  if (paymentMethodId) {
    const params = {
      amount: orderAmount,
      confirm: true,
      confirmation_method: "manual",
      currency,
      payment_method: paymentMethodId,
      use_stripe_sdk: useStripeSdk,
      return_url: "risu://stripe-redirect",
    };
    const intent = await stripe.paymentIntents.create(params);
    return res.send(generateResponse(intent));
  }
});

module.exports = router;
