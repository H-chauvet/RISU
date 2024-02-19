const { db } = require("../../middleware/database");

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

exports.getContainerByOrganizationId = (organizationId) => {
  return db.Containers.findMany({
    where: {
      organizationId: parseInt(organizationId),
    },
    select: {
      id: true,
      city: true,
      address: true,
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

exports.createContainer2 = (container) => {
  container.price = 10;
  return db.Containers.create({
    data: container,
  });
};

exports.deleteContainer = (id) => {
  return db.Containers.delete({
    where: {
      id: id,
    },
  });
};

exports.createContainer = (container) => {
  container.width = parseFloat(container.width);
  container.height = parseFloat(container.height);
  return db.Containers.create({
    data: container,
  });
};

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

exports.getAllContainers = async () => {
  try {
    return db.Containers.findMany();
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw new Error("Failed to retrieve containers");
  }
};

exports.createContainer2 = (container) => {
  container.price = parseFloat(container.price);
  return db.Containers.create({
    data: container,
  });
};

exports.getItemsFromContainer = (containerId) => {
  return db.Containers.findUnique({
    where: { id: containerId },
    select: {
      items : true
    },
  })
}
