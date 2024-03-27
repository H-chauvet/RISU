const { db } = require('../../middleware/database')

/**
 * Retrieve every item from a container
 *
 * @param {number} containerId id of the container
 * @returns every item in a specific container
 */
exports.getAllItem = (containerId) => {
  return db.Item.findMany({
    where: {
      containerId: containerId,
    },
  });
};

/**
 * Retrieve a specific item
 *
 * @param {number} id of the item
 * @returns one item if an id correspond
 */
exports.getItemFromId = (id) => {
  intId = parseInt(id)
  return db.Item.findUnique({
    where: { id: intId }
  })
}

/**
 * Retrieve every item in the database
 *
 * @returns every item in the database
 */
exports.getItems = () => {
  return db.Item.findMany()
}

/**
 * Delete a specific item
 *
 * @param {number} id of the item to be deleted
 * @returns none
 */
exports.deleteItem = (id) => {
  return db.Item.delete({
    where: {
      id: id,
    },
  });
};

/**
 * Create a new item ensuring that the price is a float
 *
 * @param {*} item object that contains the data
 * @returns the new object stored in the database
 */
exports.createItem = (item) => {
  item.price = parseFloat(item.price);
  return db.Item.create({
    data: item,
  });
};

/**
 * Update an item ensuring that the price is a float
 *
 * @param {number} id of the item to be updated
 * @param {*} item object that contains the data to update the item
 * @returns the freshly updated object
 */
exports.updateItem = (id, item) => {
  intId = parseInt(id)
  item.price = parseFloat(item.price);
  return db.Item.update({
    where: {
      id: intId,
    },
    data: item,
  });
};

/**
 * Get the number of available items in a container
 *
 * @param {number} containerId id of the container
 * @returns the number of available item in the containers
 */
exports.getAvailableItemsCount = (containerId) => {
  return db.Item.count({
    where: { containerId: containerId },
    select: { available: true }
  })
}
