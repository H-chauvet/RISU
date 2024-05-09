const { db } = require('../../middleware/database')

/**
 * Create a favorite item for the specified user
 *
 * @param {*} userId that added the item
 * @param {*} itemId to be added
 * @returns the newly created favorite
 */
exports.createFavoriteItem = (userId, itemId) => {
  return db.Favorite_Article_Mobile.create({
    data: {
      userId: userId,
      itemId: itemId,
    }
  })
}

/**
 * Get all the favorites items related to a userId
 *
 * @param {*} userId of the related user
 * @returns all the favorites of the user
 */
exports.getUserFavorites = (userId) => {
  return db.Favorite_Article_Mobile.findMany({
    where: { userId: userId },
    select: {
      id: true,
      item: {
        select: {
          id: true,
          name: true,
          price: true,
          available: true,
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
 * Get a favorite item from the related item and user
 *
 * @param {*} userId of the user
 * @param {*} itemId of the item
 * @returns the related favorite
 */
exports.getItemFavorite = (userId, itemId) => {
  return db.Favorite_Article_Mobile.findFirst({
    where: {
      AND: [
        { userId: userId },
        { itemId: itemId },
      ]
    },
    select: {
      id: true,
      item: {
        select: {
          id: true,
          name: true,
          available: true,
        }
      }
    }
  })
}

/**
 * Check if a user already put an item as favorite
 * 
 * @param {*} userId of the user
 * @param {*} itemId of the item
 * @returns a boolean depending if the item is already as favorite for the user
 */
exports.checkFavorite = (userId, itemId) => {
  return db.Favorite_Article_Mobile.count({
    where: {
      AND: [
        { userId: userId },
        { itemId: itemId },
      ]
    }
  }).then(Boolean)
}

/**
 * delete a specific favorite item from its id
 *
 * @param {*} favoriteId of the related favorite item
 * @returns none
 */
exports.deleteFavorite = (favoriteId) => {
  return db.Favorite_Article_Mobile.delete({
    where: { id: favoriteId },
  })
}

/**
 * Delete the user favorite before deleting the user
 *
 * @param {*} userId of the user
 * @returns none
 */
exports.cleanUserFavorite = (userId) => {
  return db.Favorite_Article_Mobile.deleteMany({
    where: { userId: userId },
  })
}