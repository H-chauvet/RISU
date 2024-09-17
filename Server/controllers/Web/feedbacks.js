const { db } = require("../../middleware/database");

/**
 * Create a new feedback
 *
 * @param {*} data of the feedback to be created
 * @throws {Error} with a specific message to find the problem
 * @returns the newly created feedback
 */
exports.registerFeedbacks = async (res, data) => {
  try {
    const feedback = await db.Feedbacks_Web.create({
      data: data,
    });

    return feedback;
  } catch (error) {
    throw res.__("errorOccurred");
  }
};

/**
 * Get every feedbacks that correspond to the mark
 * If mark is not defined, retrieve every feedbacks
 *
 * @param {string} mark of the feedback
 * @throws {Error} if the data retrieve has failed and log the error
 * @returns the found feedbacks
 */
exports.getAllFeedbacks = async (res, mark) => {
  try {
    const filter = mark ? { mark } : {};

    const feedbacks = await db.Feedbacks_Web.findMany({
      where: filter,
    });

    return feedbacks;
  } catch (error) {
    console.error("Error retrieving feedbacks:", error);
    throw res.__("errorOccurred");
  }
};
