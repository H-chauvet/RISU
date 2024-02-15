const { db } = require('../../middleware/database')

exports.rentItem = (price, itemId, userId, duration) => {
  return db.Location_Mobile.create({
      data: {
        price: price,
        itemId: itemId,
        userId: userId,
        duration: duration,
      }
    })
}

exports.getUserRents = (userId) => {
  return db.Location_Mobile.findMany({
    where: { userId: userId },
    select: {
      id: true,
      price: true,
      createdAt: true,
      duration: true,
      ended: true,
      item: {
        select: {
          id: true,
          name: true,
          container: {
            select: {
              id: true,
              address: true,
              city:true,
            }
          }
        }
      }
    },
    orderBy: {
      createdAt: 'desc',
    }
  })
}

exports.getRentFromId = (rentId) => {
  return db.Location_Mobile.findUnique({
    where: {
      id: rentId
    },
    select: {
      id: true,
      price: true,
      createdAt: true,
      duration: true,
      userId: true,
      ended: true,
      item: {
        select: {
          id: true,
          name: true,
          container: {
            select: {
              id: true,
              address: true,
              city:true,
            }
          }
        }
      }
    }
  })
}

exports.returnRent = (rentId) => {
  return db.Location_Mobile.update({
    where: { id: rentId },
    data: {
      ended: true,
      item: {
        update: { available: true }
      }
    },
  })
}