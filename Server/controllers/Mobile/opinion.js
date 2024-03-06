const { db } = require('../../middleware/database')

/**
 * Create an opinion for the mobile app
 *
 * @param {number} userId of the one of submitted the opinion
 * @param {string} note
 * @param {string} comment
 * @returns
 */
exports.createOpinion = (userId, note, comment) => {
  return db.Opinions_Mobile.create({
      data: {
        userId: userId,
        date: new Date(),
        note: note,
        comment: comment,
      }
    })
}

/**
 * Get every opinions of a specific note
 * If note is not specified, retrieve every opinions
 *
 * @param {string} note
 * @returns the opinion that correspond to the note
 */
exports.getOpinions = (note = null) => {
  if (note) {
    return db.Opinions_Mobile.findMany({
      where: { note: note }
    })
  } else {
    return db.Opinions_Mobile.findMany()
  }
}
