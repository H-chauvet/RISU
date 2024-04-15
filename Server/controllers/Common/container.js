const { db } = require("../../middleware/database");

/**
 * Get a unique container by its id
 *
 * @param {number} id of the container object
 * @returns a container object in case it's found, otherwise empty
 */
exports.getContainerById = (id) => {
  return db.Containers.findUnique({
    where: { id: parseInt(id) },
    })
};

exports.getContainerByOrganizationId = (organizationId) => {
  return db.Containers.findMany({
    where: {
      organizationId: parseInt(organizationId),
    },
    select: {
      id: true,
      city: true,
      address: true,
      informations: true,
      items: {
        where: {
          available: true,
        },
      },
    },
  });
};

exports.getAllContainer = (id) => {
  return db.Containers.findMany();
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
      items : true
    },
  })
}

exports.updateCity = container => {
  return db.Containers.update({
    where: {
      id: container.id,
    },
    data: {
      city: container.city,
    },
  });
};

exports.updateAddress = container => {
  return db.Containers.update({
    where: {
      id: container.id,
    },
    data: {
      address: container.address,
    },
  });
};

exports.updateSaveName = container => {
  return db.Containers.update({
    where: {
      id: container.id,
    },
    data: {
      saveName: container.saveName,
    },
  });
};

exports.updateInformation = container => {
  return db.Containers.update({
    where: {
      id: container.id,
    },
    data: {
      informations: container.informations,
    },
  });
};