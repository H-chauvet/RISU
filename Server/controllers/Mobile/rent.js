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
  id = parseInt(rentId)
  return db.Location_Mobile.findUnique({
    where: {
      id: id
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
  id = parseInt(rentId)
  return db.Location_Mobile.update({
    where: { id: id },
    data: {
      ended: true,
      item: {
        update: { available: true }
      }
    },
  })
}
