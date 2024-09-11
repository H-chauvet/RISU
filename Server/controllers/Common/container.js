const { db } = require("../../middleware/database");

/**
 * Get a unique container by its id
 *
 * @param {number} id of the container object
 * @throws {Error} with a specific message to find the problem
 * @returns a container object in case it's found, otherwise empty
 */
exports.getContainerById = async (res, id) => {
  try {
    let idtest = parseInt(id);
    return await db.Containers.findUnique({
      where: { id: idtest },
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
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {number} organizationId of the container
 * @throws {Error} with a specific message to find the problem
 * @returns containers of the organization
 */
exports.getContainerByOrganizationId = async (res, organizationId) => {
  try {
    return await db.Containers.findMany({
      where: {
        organizationId: parseInt(organizationId),
      },
      select: {
        id: true,
        city: true,
        address: true,
        informations: true,
        paid: true,
        saveName: true,
        width: true,
        height: true,
        designs: true,
        price: true,
        latitude: true,
        longitude: true,
        containerMapping: true,
        items: {
          where: {
            available: true,
          },
        },
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} id
 * @throws {Error} with a specific message to find the problem
 * @returns all containers
 */
exports.getAllContainer = async (res, id) => {
  try {
    return await db.Containers.findMany();
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Retrieve all containers with specific datas
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every exitsting container
 */
exports.listContainers = async (res) => {
  try {
    return db.containers.findMany({
      select: {
        id: true,
        address: true,
        city: true,
        longitude: true,
        latitude: true,
        _count: {
          select: {
            items: {
              where: {
                available: true,
              },
            },
          },
        },
      },
    });
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw res.__("errorOccured");
  }
};

/**
 * Delete a unique container by its id
 *
 * @param {number} id of the container object
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.deleteContainer = async (res, id) => {
  try {
    return await db.Containers.delete({
      where: {
        id: id,
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Create a new container
 *
 * @param {*} container the object with data
 * @throws {Error} with a specific message to find the problem
 * @returns the container object
 */
exports.createContainer = async (res, container, organizationId) => {
  try {
    container.width = parseFloat(container.width);
    container.height = parseFloat(container.height);

    const containerObj = await db.Containers.create({
      data: container,
    });

    await db.Organization.update({
      where: {
        id: organizationId,
      },
      data: {
        containers: {
          connect: {
            id: containerObj.id,
          },
        },
      },
    });

    return containerObj;
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Update an existing container
 *
 * @param {number} id of the container
 * @param {*} container the object with updated data
 * @throws {Error} with a specific message to find the problem
 * @returns the container object
 */
exports.updateContainer = async (res, id, container) => {
  try {
    container.price = parseFloat(container.price);
    container.width = parseFloat(container.width);
    container.height = parseFloat(container.height);
    return await db.Containers.update({
      where: {
        id: id,
      },
      data: container,
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {number} id of the container
 * @param {*} container the object with position data
 * @throws {Error} with a specific message to find the problem
 * @returns the container object
 */
exports.updateContainerPosition = async (res, id, container) => {
  try {
    container.latitude = parseFloat(container.latitude);
    container.longitude = parseFloat(container.longitude);
    return await db.Containers.update({
      where: {
        id: id,
      },
      data: container,
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} position the object with position data
 * @throws {Error} with a specific message to find the problem
 * @returns the city and adress of the position
 */
exports.getLocalisation = async (res, position) => {
  const response = await fetch(
    "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
      position.latitude +
      "," +
      position.longitude +
      "&result_type=street_address&key=" +
      process.env.GOOGLE_API_KEY
  );

  const responseJson = await response.json();

  if (responseJson.status === "OK") {
    let address = "";
    let city = "";
    for (
      let i = 0;
      i < responseJson.results[0].address_components.length;
      i++
    ) {
      if (responseJson.results[0].address_components[i].types[0] === "route") {
        address = responseJson.results[0].address_components[i].long_name;
      }
      if (
        responseJson.results[0].address_components[i].types[0] === "locality"
      ) {
        city = responseJson.results[0].address_components[i].long_name;
      }
    }
    return { address: address, city: city };
  } else if (responseJson.status === "ZERO_RESULTS") {
    return "No address found";
  }
};

/**
 *
 * @param {*} position the object with position data
 * @returns the city and adress of the position
 */
exports.getLocalisation = async (position) => {
  const response = await fetch(
    "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
      position.latitude +
      "," +
      position.longitude +
      "&result_type=street_address&key=" +
      process.env.GOOGLE_API_KEY
  );

  const responseJson = await response.json();

  if (responseJson.status === "OK") {
    let address = "";
    let city = "";
    for (
      let i = 0;
      i < responseJson.results[0].address_components.length;
      i++
    ) {
      if (responseJson.results[0].address_components[i].types[0] === "route") {
        address = responseJson.results[0].address_components[i].long_name;
      }
      if (
        responseJson.results[0].address_components[i].types[0] === "locality"
      ) {
        city = responseJson.results[0].address_components[i].long_name;
      }
    }
    return { address: address, city: city };
  } else if (responseJson.status === "ZERO_RESULTS") {
    return "No address found";
  }
};

/**
 * Retrieve every container
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every exitsting container
 */
exports.getAllContainers = async (res) => {
  try {
    return await db.Containers.findMany();
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Retrieve items of the containers
 *
 * @param {number} containerId id of the container
 * @returns the container object with its items
 * @throws {Error} with a specific message to find the problem
 */
exports.getItemsFromContainer = async (res, containerId) => {
  try {
    return await db.Containers.findUnique({
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
            description: true,
            categories: true,
          },
        },
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} container with informations to update
 * @throws {Error} with a specific message to find the problem
 * @returns the updated container
 */
exports.updateCity = async (res, container) => {
  try {
    return await db.Containers.update({
      where: {
        id: container.id,
      },
      data: {
        city: container.city,
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} container with informations to update
 * @throws {Error} with a specific message to find the problem
 * @returns the updated container
 */
exports.updateAddress = async (res, container) => {
  try {
    return await db.Containers.update({
      where: {
        id: container.id,
      },
      data: {
        address: container.address,
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} container with informations to update
 * @throws {Error} with a specific message to find the problem
 * @returns the updated container
 */
exports.updateSaveName = async (res, container) => {
  try {
    return await db.Containers.update({
      where: {
        id: container.id,
      },
      data: {
        saveName: container.saveName,
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 *
 * @param {*} container with informations to update
 * @throws {Error} with a specific message to find the problem
 * @returns the updated container
 */
exports.updateInformation = async (res, container) => {
  try {
    return await db.Containers.update({
      where: {
        id: container.id,
      },
      data: {
        informations: container.informations,
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Retrieve items of the containers with filters
 *
 * @param {number} containerId id of the container
 * @param {string} articleName name of the article
 * @param {boolean} isAscending order of the items
 * @param {boolean} isAvailable availability of the items
 * @param {number} categoryId id of the category
 * @param {string} sortBy sort by price or rating
 * @param {number} min minimum value
 * @param {number} max maximum value
 * @throws {Error} with a specific message to find the problem
 * @returns the container object with its items
 */
exports.getItemsWithFilters = async (
  res,
  containerId,
  articleName,
  isAscending,
  isAvailable,
  categoryId,
  sortBy,
  min,
  max
) => {
  try {
    const container = await this.getContainerById(res, containerId);
    if (!container) {
      throw res.__("containerNotFound");
    }

    let whereCondition = {
      containerId: containerId,
      name: {
        contains: articleName,
      },
    };

    if (categoryId != undefined) {
      if (categoryId != null) {
        categoryId = parseInt(categoryId);
        if (isNaN(categoryId)) {
          throw res.__("invalidCategoryId");
        }
        whereCondition.categories = { some: { id: categoryId } };
      }
    }

    if (sortBy === "price") {
      whereCondition.price = {
        gte: min,
        lte: max,
      };
    }

    if (sortBy === "rating") {
      whereCondition.rating = {
        gte: min,
        lte: max,
      };
    }

    const orderBy = isAscending ? "asc" : "desc";

    let items = await db.Item.findMany({
      where: whereCondition,
      select: {
        id: true,
        name: true,
        available: true,
        createdAt: true,
        containerId: true,
        price: true,
        description: true,
        categories: true,
      },
      orderBy: {
        [sortBy]: orderBy,
      },
    });

    if (isAvailable) {
      items = items.filter((item) => item.available);
    }

    items.sort((a, b) => {
      return isAscending ? a[sortBy] - b[sortBy] : b[sortBy] - a[sortBy];
    });

    return items;
  } catch (error) {
    throw res.__("errorOccured");
  }
};
