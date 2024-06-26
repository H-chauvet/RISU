const Stripe = require("stripe");
const { db } = require("../../middleware/database");

/**
 * Generate a response depending on the status of the payment
 *
 * @param {number} intent stripe object
 * @param {*} id id of the container
 * @returns the corresponding response
 */
const generateResponse = async (intent, id) => {
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
      try {
        await db.Containers.update({
          where: {
            id: id,
          },
          data: { paid: true },
        });
      } catch (error) {
        console.error("Error retrieving users:", error);
        throw new Error("Failed to retrieve container");
      }
      return { clientSecret: intent.client_secret, status: intent.status };
  }

  return {
    error: "Failed",
  };
};

/**
 * Realize a payment with the provided data
 *
 * @param {*} data for the payment
 * @returns a response for the payment
 */
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
    return generateResponse(intent, data.containerId);
  }
};
