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

exports.makePayments = async (data) => {
  const stripe = new Stripe(process.env.STRIPE_SECRET, {
    apiVersion: "2023-08-16",
    typescript: false,
  });

  if (data.paymentMethodId) {
    const params = {
      amount: data.amount * 100,
      confirm: true,
      confirmation_method: "manual",
      currency: data.currency,
      payment_method: data.paymentMethodId,
      use_stripe_sdk: data.useStripeSdk,
      return_url: "risu://stripe-redirect",
    };
    const intent = await stripe.paymentIntents.create(params);
    return generateResponse(intent);
  }
};
