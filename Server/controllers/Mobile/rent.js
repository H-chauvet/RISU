const { db } = require('../../middleware/database')

/**
 * Create a rent related to an item
 *
 * @param {number} price of the item
 * @param {*} itemId to be rent
 * @param {*} userId of the one who rent
 * @param {*} duration of the rent
 * @returns the freshly rented item
 */
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

/**
 * Get rents of the user
 *
 * @param {number} userId of the one who rent
 * @returns rents of the user
 */
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

/**
 * Get rent data from its id
 *
 * @param {number} rentId of the searched rent
 * @returns the rent of the data if found
 */
exports.getRentFromId = (rentId) => {
  const id = parseInt(rentId);
  return db.Location_Mobile.findUnique({
    where: {
      id: id
    },
    select: {
      id: true,
      invoice: true,
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

/**
 * Update the rent status to available
 *
 * @param {string} rentId to be updated
 * @returns the freshly updated location
 */
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

/**
 * Update the rent invoice
 *
 * @param {string} rentId id of the rend
 * @param {*} invoiceData the invoice file
 * @returns the freshly updated location
 */
exports.updateRentInvoice = (rentId, invoiceData) => {
  const id = parseInt(rentId);
  return db.Location_Mobile.update({
    where: { id: id },
    data: { invoice: invoiceData }
  });
}

/**
 * Delete every rent of the user to available before deleting his account
 *
 * @param {*} userId of the user
 * @returns none
 */
exports.returnAllUserRents = async (userId) => {
  rents = await this.getUserRents(userId)

  rents.forEach(async element => {
    await this.returnRent(element["id"])
  });
  return db.Location_Mobile.deleteMany({
    where: { userId: userId },
  })
}