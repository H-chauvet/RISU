const { db } = require("../../middleware/database");

exports.getContainer = (id) => {
  return db.Containers_Web.findMany({
    where: {
      id: id,
    },
  });
};

exports.getAllContainer = (id) => {
  return db.Containers_Web.findMany();
};

exports.createContainer2 = (container) => {
  container.price = 10;
  return db.Containers_Web.create({
    data: container,
  });
};

exports.deleteContainer = (id) => {
  return db.Containers_Web.delete({
    where: {
      id: id,
    },
  });
};

exports.createContainer = (container) => {
  container.width = parseFloat(container.width);
  container.height = parseFloat(container.height);
  return db.Containers_Web.create({
    data: container,
  });
};

exports.updateContainer = (id, container) => {
  container.price = parseFloat(container.price);
  container.width = parseFloat(container.width);
  container.height = parseFloat(container.height);
  return db.Containers_Web.update({
    where: {
      id: id,
    },
    data: container,
  });
};

exports.getAllContainers = async () => {
  try {
    const users = await db.Containers_Web.findMany();
    return users;
  } catch (error) {
    console.error("Error retrieving users:", error);
    throw new Error("Failed to retrieve users");
  }
};

exports.createContainer2 = (container) => {
  container.price = parseFloat(container.price);
  return db.Containers_Web.create({
    data: container,
  });
};
