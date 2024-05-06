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
  const opinion = db.Opinions_Mobile.create({
    data: {
      userId: userId,
      date: new Date(),
      note: note,
      comment: comment,
      itemId: itemID
    }
  }).then((opinion) => {
    const itemPromise = db.Item.findUnique({
        where: { id: itemID }
      });

      itemPromise.then((item) => {
        if (item) {
          const opinionsPromise = db.Opinions_Mobile.findMany({
            where: { itemId: itemID }
          });

          opinionsPromise.then((opinions) => {
            if (opinions && opinions.length > 0) {
              var sum = 0;
              opinions.forEach(opinion => {
                sum += parseFloat(opinion.note);
              });
              const rating = sum / opinions.length;

              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: rating
                }
              }).then(() => {
                db.Item.findUnique({
                  where: { id: itemID }
                })
              });
            } else {
              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: note
                }
              }).then(() => {
                db.Item.findUnique({
                  where: { id: itemID }
                })
              });
            }
          });
        }
      });
  });
  return opinion;
};


/**
 * Get every opinions from an article
 * If note is not specified, retrieve every opinions
 * If note is specified, retrieve only the opinions that correspond to the note
 *
 * @param {number} itemId of the item
 * @param {string} note
 * @returns the opinion that correspond to the note
 */
exports.getOpinions = (itemId, note = null) => {
  db.Item.findUnique({
    where: { id: itemId }
  })

  if (note) {
    return db.Opinions_Mobile.findMany({
      where: { note: note, itemId: itemId },
      select: {
        id: true,
        userId: true,
        date: true,
        comment: true,
        note: true,
        itemId: true,
        user: {
          select: {
            firstName: true,
            lastName: true,
          }
        }
      }
    })
  } else {
    return db.Opinions_Mobile.findMany({
      where: { itemId: itemId },
      select: {
        id: true,
        userId: true,
        date: true,
        comment: true,
        note: true,
        itemId: true,
        user: {
          select: {
            firstName: true,
            lastName: true,
          }
        }
      }
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
  const opinionPromise = db.Opinions_Mobile.findUnique({
    where: { id: opinionId }
  });

  opinionPromise.then((opinion) => {
    const itemID = opinion.itemId;
    const DeletedOpinionPromise = db.Opinions_Mobile.delete({
      where: { id: opinionId }
    });

    DeletedOpinionPromise.then(() => {
      const itemPromise = db.Item.findUnique({
        where: { id: itemID }
      });

      itemPromise.then((item) => {
        if (item) {
          const opinionsPromise = db.Opinions_Mobile.findMany({
            where: { itemId: itemID }
          });

          opinionsPromise.then((opinions) => {
            if (opinions && opinions.length > 0) {
              const sum = opinions.reduce((acc, opinion) => acc + parseFloat(opinion.note), 0);
              const rating = sum / opinions.length;

              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: rating
                }
              }).then(() => {
                db.Item.findUnique({
                  where: { id: itemID }
                })
              });
            } else {
              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: 0
                }
              }).then(() => {
                db.Item.findUnique({
                  where: { id: itemID }
                })
              });
            }
          });
        }
      });
    });
  });
};

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
  const opinion = db.Opinions_Mobile.update({
    where: { id: opinionId },
    data: {
      note: note,
      comment: comment
    }
  }).then((opinion) => {
    const itemID = opinion.itemId;
    const itemPromise = db.Item.findUnique({
        where: { id: itemID }
      });

      itemPromise.then((item) => {
        if (item) {
          const opinionsPromise = db.Opinions_Mobile.findMany({
            where: { itemId: itemID }
          });

          opinionsPromise.then((opinions) => {
            if (opinions && opinions.length > 0) {
              var sum = 0;
              opinions.forEach(opinion => {
                sum += parseFloat(opinion.note);
              });
              const rating = sum / opinions.length;

              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: rating
                }
              })
            } else {
              db.Item.update({
                where: { id: itemID },
                data: {
                  rating: note
                }
              })
            }
          });
        }
      });
  });

  return opinion;
}
