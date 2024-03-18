const { db } = require('../../middleware/database')


/**
 * Create an opinion for an article
 *
 * @param {number} itemId of the item
 * @param {number} userId of the one of submitted the opinion
 * @param {string} note
 * @param {string} comment
 * @returns the newly created opinion
 */
exports.createOpinion = (itemID, userId, note, comment) => {

  return db.Opinions_Mobile.create({
      data: {
        userId: userId,
        date: new Date(),
        note: note,
        comment: comment,
        itemId: itemID
      }
    })
}


/**
 * Get every opinions of a specific note
 * If note is not specified, retrieve every opinions
 *
 * @param {number} itemId of the item
 * @param {string} note
 * @returns the opinion that correspond to the note
 */
exports.getOpinions = (itemId, note = null) => {

  if (note) {
    return db.Opinions_Mobile.findMany({
      where: { note: note, itemId: itemId }
    })
  } else {
    return db.Opinions_Mobile.findMany({
      where: { itemId: itemId }
    })
  }
}

/**
 * Delete an opinion
 *
 * @param {number} opinionId of the opinion to be deleted
 * @returns a promise indicating the success or failure of the deletion operation
 */
exports.deleteOpinion = (opinionId) => {
  return db.Opinions_Mobile.delete({
    where: { id: opinionId }
  })
}

/**
 * Get an opinion from its id
 *
 * @param {number} opinionId
 * @returns the opinion corresponding to the id
 */
exports.getOpinionFromId = (opinionId) => {
  return db.Opinions_Mobile.findUnique({
    where: { id: opinionId }
  })
}

/**
 * Update an existing opinion
 *
 * @param {number} opinionId of the opinion to be updated
 * @param {string} note The new note to be associated with the opinion
 * @param {string} comment The new comment to be associated with the opinion
 * @returns a promise indicating the success or failure of the update operation
 */
exports.updateOpinion = (opinionId, note, comment) => {
  return db.Opinions_Mobile.update({
    where: { id: opinionId },
    data: {
      note: note,
      comment: comment
    }
  })
}
