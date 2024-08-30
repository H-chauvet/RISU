const { db } = require("../../middleware/database");

/**
 * Retrieve every item category
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every item category
 */
exports.getItemCategories = async () => {
  try {
    return await db.Item_Category.findMany();
  } catch (err) {
    throw "Something happen while retrieving item categories";
  }
};

/**
 * Retrieve a specific item category
 *
 * @param {number} id of the item category
 * @throws {Error} with a specific message to find the problem
 * @returns one item if an id correspond
 */
exports.getItemCategoryFromId = async (id) => {
  try {
    intId = parseInt(id);
    return await db.Item_Category.findUnique({
      where: { id: intId },
    });
  } catch (err) {
    throw "Something happen while retrieving item categories";
  }
};

/**
 * Create a new item category
 *
 * @param {string} name of the item category
 * @throws {Error} with a specific message to find the problem
 * @returns the new object stored in the database
 */
exports.createItemCategory = async (name) => {
  try {
    return await db.Item_Category.create({
      data: {
        name: name,
      },
    });
  } catch (err) {
    throw "Something happen while creating item category";
  }
};

/**
 * Update an item category
 *
 * @param {string} name of the item category
 * @throws {Error} with a specific message to find the problem
 * @returns the freshly updated object
 */
exports.updateItemCategory = async (id, name) => {
  try {
    return await db.Item_Category.update({
      where: { id: id },
      data: {
        name: name,
      },
    });
  } catch (err) {
    throw "Something happen while updating item category";
  }
};

/**
 * Delete a specific item category
 *
 * @param {number} id of the item category to be deleted
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.deleteItemCategory = async (id) => {
  try {
    return await db.Item_Category.delete({
      where: { id: id },
    });
  } catch (err) {
    throw "Something happen while deleting item category";
  }
};

/**
 * Set the item categories of an item
 * Can be used to add or remove categories
 * Can add/remove multiple categories at once
 *
 * @param {number} id of the item
 * @param {Array} categories array of item categories id
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.setItemCategories = async (id, categories) => {
  try {
    return await db.Item.update({
      where: { id: id },
      data: {
        categories: {
          set: categories,
        },
      },
    });
  } catch (err) {
    throw "Something happen while setting item categories";
  }
};
