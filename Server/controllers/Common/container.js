const { db } = require("../../middleware/database");

/**
 * Get a unique container by its id
 *
 * @param {number} id of the container object
 * @returns a container object in case it's found, otherwise empty
 */
exports.getContainerById = (id) => {
  return db.Containers.findUnique({
    where: { id: id },
    select: {
      city: true,
      address: true,
      items: {
        where: { available: true },
      },
      latitude: true,
      longitude: true,
    },
  });
};

/**
 * Delete a unique container by its id
 *
 * @param {number} id of the container object
 * @returns none
 */
exports.deleteContainer = (id) => {
  return db.Containers.delete({
    where: {
      id: id,
    },
  });
};

/**
 * Create a new container
 *
 * @param {*} container the object with data
 * @returns the container object
 */
exports.createContainer = (container) => {
  container.width = parseFloat(container.width);
  container.height = parseFloat(container.height);
  return db.Containers.create({
    data: container,
  });
};

/**
 * Update an existing container
 *
 * @param {number} id of the container
 * @param {*} container the object with updated data
 * @returns the container object
 */
exports.updateContainer = (id, container) => {
  container.price = parseFloat(container.price);
  container.width = parseFloat(container.width);
  container.height = parseFloat(container.height);
  return db.Containers.update({
    where: {
      id: id,
    },
    data: container,
  });
};

/**
 *
 * @param {number} id of the container
 * @param {*} container the object with position data
 * @returns the container object
 */
exports.updateContainerPosition = (id, container) => {
  container.latitude = parseFloat(container.latitude);
  container.longitude = parseFloat(container.longitude);
  return db.Containers.update({
    where: {
      id: id,
    },
    data: container,
  });
};

/**
 * Retrieve every container
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every exitsting container
 */
exports.getAllContainers = async () => {
  try {
    return db.Containers.findMany();
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw new Error("Failed to retrieve containers");
  }
};

/**
 * Retrieve items of the containers
 *
 * @param {number} containerId id of the container
 * @returns the container object with its items
 */
exports.getItemsFromContainer = (containerId) => {
  return db.Containers.findUnique({
    where: { id: containerId },
    select: {
      items: {
        select: {
          id: true,
          name: true,
          available: true,
          createdAt: true,
          containerId: true,
          price: true,
          image: true,
          description: true,
          categories: true,
        },
      },
    },
  });
};

exports.getItemsWithFilters = async (containerId, articleName, isAscending, isAvailable, categoryId) => {
  try {
    const container = await db.Containers.findUnique({
      where: { id: containerId },
    });
    if (!container) {
      throw new Error("Container not found");
    }
    const orderBy = isAscending === true ? 'asc' : 'desc';
    return await db.Item.findMany({
      where: {
        name: {
          contains: articleName,
        },
        available: isAvailable,
        categories: categoryId ? { some: { id: parseInt(categoryId) } } : undefined,
      },
      select: {
        id: true,
        name: true,
        available: true,
        createdAt: true,
        containerId: true,
        price: true,
        image: true,
        description: true,
        categories: true,
      },
      orderBy: {
        price: orderBy,
      }
    });
  } catch (error) {
    console.error("Error retrieving items with filters:", error);
    throw new Error("Failed to retrieve items with filters");
  }
};
