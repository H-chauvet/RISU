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
          where: { available: true }
        },
      }
    })
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
 * Create a new container by its id
 *
 * @param {number} id of the container object
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
 * @param {number} id of the container object
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
 * Retrieve every container
 *
 * @returns every exitsting container
 * @throws {Error} with a specific message to find the problem
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
 * Retrieve the items of the containers
 *
 * @param {number} containerId of the container object
 * @returns the container object with its items
 */
exports.getItemsFromContainer = (containerId) => {
  return db.Containers.findUnique({
    where: { id: containerId },
    select: {
      items : true
    },
  })
}
