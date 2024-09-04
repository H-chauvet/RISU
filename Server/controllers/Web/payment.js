const Stripe = require("stripe");
const { db } = require("../../middleware/database");

/**
 * Generate a response depending on the status of the payment
 *
 * @param {number} intent stripe object
 * @param {*} id id of the container
 * @throws {Error} with a specific message to find the problem
 * @returns the corresponding response
 */
const generateResponse = async (res, intent, id) => {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.client_secret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      throw res.__("cardBlocked");
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
        throw res.__("errorOccured");
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
 * @throws {Error} with a specific message to find the problem
 * @returns a response for the payment
 */
exports.makePayments = async (res, data) => {
  try {
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
    }
  } catch (err) {
    throw res.__("errorOccured");
  }
  return generateResponse(res, intent, data.containerId);
};
