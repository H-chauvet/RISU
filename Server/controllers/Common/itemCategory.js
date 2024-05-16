const { db } = require('../../middleware/database')

/**
 * Retrieve every item category
 *
 * @returns every item category
 */
exports.getItemCategories = () => {
  return db.Item_Category.findMany()
}

/**
 * Retrieve a specific item category
 *
 * @param {number} id of the item category
 * @returns one item if an id correspond
 */
exports.getItemCategoryFromId = (id) => {
  intId = parseInt(id)
  return db.Item_Category.findUnique({
    where: { id: intId }
  })
}

/**
 * Create a new item category
 *
 * @param {string} name of the item category
 * @returns the new object stored in the database
 */
exports.createItemCategory = (name) => {
  return db.Item_Category.create({
    data: {
      name: name
    }
  })
}

/**
 * Update an item category
 *
 * @param {string} name of the item category
 * @returns the freshly updated object
 */
exports.updateItemCategory = (id, name) => {
  return db.Item_Category.update({
    where: { id: id },
    data: {
      name: name
    }
  })
}

/**
 * Delete a specific item category
 *
 * @param {number} id of the item category to be deleted
 * @returns none
 */
exports.deleteItemCategory = (id) => {
  return db.Item_Category.delete({
    where: { id: id }
  })
}

/**
 * Set the item categories of an item
 * Can be used to add or remove categories
 * Can add/remove multiple categories at once
 *
 * @param {number} id of the item
 * @param {Array} categories array of item categories id
 * @returns none
 */
exports.setItemCategories = (id, categories) => {
  return db.Item.update({
    where: { id: id },
    data: {
      categories: {
        set: categories
      }
    }
  });
}


