const { db } = require('../../middleware/database')

exports.registerFeedbacks = data => {
    return db.Feedbacks_Web.create({
      data: data
    })
  }

  exports.getAllFeedbacks = async (mark) => {
    try {
      const filter = mark ? { mark } : {};

      const feedbacks = await db.Feedbacks_Web.findMany({
        where: filter
      });

      return feedbacks;
    } catch (error) {
      console.error('Error retrieving feedbacks:', error);
      throw new Error('Failed to retrieve feedbacks');
    }
  };