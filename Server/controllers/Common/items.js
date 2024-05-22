const { db } = require("../../middleware/database");

/**
 * Retrieve every item from a container
 *
 * @param {number} containerId id of the container
 * @returns every item in a specific container
 */
exports.getItemByContainerId = (containerId) => {
  return db.Item.findMany({
    where: {
      containerId: containerId,
    },
  });
};

/**
 * Retrieve every item with category from a container
 *
 * @param {number} category category of the items
 * @returns every item with specific category in a specific container
 */
exports.getItemByCategory = (category) => {
  return db.Item.findMany({
    where: {
      category: category,
    },
  });
};

/**
 * Retrieve every item
 *
 * @returns every item in the database
 */
exports.getAllItem = () => {
  return db.Item.findMany({});
};

/**
 * Retrieve a specific item
 *
 * @param {number} id of the item
 * @returns one item if an id correspond
 */
exports.getItemFromId = (id) => {
  return db.Item.findUnique({
    where: { id: parseInt(id) },
    include: {
      categories: true // inclure les catégories liées à l'élément
    }
  });
}

/**
 * Retrieve every item in the database
 *
 * @returns every item in the database
 */
exports.getItems = () => {
  return db.Item.findMany();
};

/**
 * Delete a specific item
 *
 * @param {number} id of the item to be deleted
 * @returns none
 */
exports.deleteItem = (id) => {
  return db.Item.delete({
    where: {
      id: parseInt(id),
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
  item.containerId = parseInt(item.containerId);
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
  intId = parseInt(id);
  item.price = parseFloat(item.price);
  return db.Item.update({
    where: {
      id: intId,
    },
    data: item,
  });
};

/**
 * Get the similar items of a specific item
 *
 * @param {number} itemId id of the item
 * @param {number} containerId id of the container
 * @returns the articles that are similar to the one in parameter
 * at least one same category
 */
exports.getAvailableItemsCount = (containerId) => {
  return db.Item.count({
    where: { containerId: containerId },
    select: { available: true }
  })
}

/**
  * Get the similar items of a specific item
  *
  * @param {number} containerId id of the container
  * @returns the articles that are similar to the one in parameter
  * at least one same category
  */
exports.getSimilarItems = async (itemId, containerId) => {
  try {
    const item = await db.Item.findUnique({
      where: { id: itemId },
      include: { categories: true },
    });
    if (!item) {
      throw new Error("Item not found");
    }

    const categoryIds = item.categories.map((category) => category.id);

    const similarItems = await db.Item.findMany({
      where: {
        containerId: containerId,
        id: { not: itemId },
        categories: {
          some: { id: { in: categoryIds } },
        },
        available: true,
      },
    });

    return similarItems;
  } catch (error) {
    throw error;
  }
}

/**
 * Update the name of the selected item
 *
 * @param {number} item information about the item
 * @returns the item with the name changed
 */
exports.updateName = (item) => {
  return db.Item.update({
    where: {
      id: item.id,
    },
    data: {
      name: item.name,
    },
  });
};

/**
 * Update the selected item
 *
 * @param {number} item information about the item
 * @returns the item with the name changed
 */
exports.updateItemCtn = (item) => {
  return db.Item.update({
    where: {
      id: item.id,
    },
    data: {
      name: item.name,
      description: item.description,
      price: item.price,
      available: item.available,
    },
  });
};

/**
 * Update the price of the selected item
 *
 * @param {number} item information about the item
 * @returns the item with the price changed
 */
exports.updatePrice = (item) => {
  return db.Item.update({
    where: {
      id: item.id,
    },
    data: {
      price: item.priceTmp,
    },
  });
};

/**
 * Update the description of the selected item
 *
 * @param {number} item information about the item
 * @returns the item with the description changed
 */
exports.updateDescription = (item) => {
  return db.Item.update({
    where: {
      id: item.id,
    },
    data: {
      description: item.description,
    },
  });
};
