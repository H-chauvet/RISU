const { db } = require('../../middleware/database')

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

exports.getOpinions = (note = null) => {
  if (note) {
    return db.Opinions_Mobile.findMany({
      where: { note: note }
    })
  } else {
    return db.Opinions_Mobile.findMany()
  }
}