const { db } = require('../../middleware/database')

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

exports.deleteOpinion = (opinionId) => {
  return db.Opinions_Mobile.delete({
    where: { id: opinionId }
  })
}

exports.getOpinionFromId = (opinionId) => {
  return db.Opinions_Mobile.findUnique({
    where: { id: opinionId }
  })
}

exports.updateOpinion = (opinionId, note, comment) => {
  return db.Opinions_Mobile.update({
    where: { id: opinionId },
    data: {
      note: note,
      comment: comment
    }
  })
}