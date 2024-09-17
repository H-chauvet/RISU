const { db } = require("../../middleware/database");

/**
 * Retrieve every item from a container
 *
 * @param {number} containerId id of the container
 * @throws {Error} with a specific message to find the problem
 * @returns every item in a specific container
 */
exports.getItemByContainerId = async (res, containerId) => {
  try {
    return await db.Item.findMany({
      where: {
        containerId: containerId,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Retrieve every item with category from a container
 *
 * @param {number} category category of the items
 * @throws {Error} with a specific message to find the problem
 * @returns every item with specific category in a specific container
 */
exports.getItemByCategory = async (res, category) => {
  try {
    return await db.Item.findMany({
      where: {
        category: category,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Retrieve every item in the database
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every item in the database
 */
exports.getAllItems = async (res) => {
  try {
    return await db.Item.findMany({});
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Retrieve a specific item
 *
 * @param {number} id of the item
 * @throws {Error} with a specific message to find the problem
 * @returns one item if an id correspond
 */
exports.getItemFromId = async (res, id) => {
  try {
    return await db.Item.findUnique({
      where: { id: parseInt(id) },
      include: {
        categories: true, // inclure les catégories liées à l'élément
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Retrieve every item in the database
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every item in the database
 */
exports.getItems = async (res) => {
  try {
    return await db.Item.findMany();
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Delete a specific item
 *
 * @param {number} id of the item to be deleted
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.deleteItem = async (res, id) => {
  try {
    return await db.Item.delete({
      where: {
        id: parseInt(id),
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Create a new item ensuring that the price is a float
 *
 * @param {*} item object that contains the data
 * @throws {Error} with a specific message to find the problem
 * @returns the new object stored in the database
 */
exports.createItem = async (res, item) => {
  try {
    item.available = item.available == "true";
    item.price = parseFloat(item.price);
    item.containerId = parseInt(item.containerId);
    return await db.Item.create({
      data: item,
    });
  } catch (err) {
    console.error(err);
    throw res.__("errorOccurred");
  }
};

/**
 * Update an item ensuring that the price is a float
 *
 * @param {number} id of the item to be updated
 * @param {*} item object that contains the data to update the item
 * @throws {Error} with a specific message to find the problem
 * @returns the freshly updated object
 */
exports.updateItem = async (res, id, item) => {
  try {
    intId = parseInt(id);
    item.price = parseFloat(item.price);
    return await db.Item.update({
      where: {
        id: intId,
      },
      data: item,
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Get the similar items of a specific item
 *
 * @param {number} itemId id of the item
 * @param {number} containerId id of the container
 * @throws {Error} with a specific message to find the problem
 * @returns the articles that are similar to the one in parameter
 * at least one same category
 */
exports.getAvailableItemsCount = async (res, containerId) => {
  try {
    return await db.Item.count({
      where: { containerId: containerId },
      select: { available: true },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Get the similar items of a specific item
 *
 * @param {number} containerId id of the container
 * @throws {Error} with a specific message to find the problem
 * @returns the articles that are similar to the one in parameter
 * at least one same category
 */
exports.getSimilarItems = async (res, itemId, containerId) => {
  try {
    const item = await db.Item.findUnique({
      where: { id: itemId },
      include: { categories: true },
    });
    if (!item) {
      throw res.__("itemNotFound");
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
    throw res.__("errorOccurred");
  }
};

/**
 * Update the name of the selected item
 *
 * @param {number} item information about the item
 * @throws {Error} with a specific message to find the problem
 * @returns the item with the name changed
 */
exports.updateName = async (res, item) => {
  try {
    return await db.Item.update({
      where: {
        id: item.id,
      },
      data: {
        name: item.name,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update the selected item
 *
 * @param {number} item information about the item
 * @throws {Error} with a specific message to find the problem
 * @returns the item with the name changed
 */
exports.updateItemCtn = async (res, item) => {
  try {
    return await db.Item.update({
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
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update the price of the selected item
 *
 * @param {number} item information about the item
 * @throws {Error} with a specific message to find the problem
 * @returns the item with the price changed
 */
exports.updatePrice = async (res, item) => {
  try {
    return await db.Item.update({
      where: {
        id: item.id,
      },
      data: {
        price: item.priceTmp,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update the description of the selected item
 *
 * @param {number} item information about the item
 * @throws {Error} with a specific message to find the problem
 * @returns the item with the description changed
 */
exports.updateDescription = async (res, item) => {
  try {
    return await db.Item.update({
      where: {
        id: item.id,
      },
      data: {
        description: item.description,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};
