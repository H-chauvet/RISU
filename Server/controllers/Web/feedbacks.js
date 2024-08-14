const { db } = require('../../middleware/database')

/**
 * Create a new feedback
 *
 * @param {*} data of the feedback to be created
 * @returns the newly created feedback
 */
exports.registerFeedbacks = async data => {
  try {
    const feedback = await db.Feedbacks_Web.create({
      data: data
    })

    return feedback;
  } catch (error) {
    throw "Something happen during the creation"
  }
}

/**
 * Get every feedbacks that correspond to the mark
 * If mark is not defined, retrieve every feedbacks
 *
 * @param {string} mark of the feedback
 * @throws {Error} if the data retrieve has failed and log the error
 * @returns the found feedbacks
 */
exports.getAllFeedbacks = async (mark) => {
  try {
    const filter = mark ? { mark } : {};

    const feedbacks = await db.Feedbacks_Web.findMany({
      where: filter
    });

    return feedbacks;
  } catch (error) {
    console.error('Error retrieving feedbacks:', error);
    throw 'Failed to retrieve feedbacks';
  }
};
