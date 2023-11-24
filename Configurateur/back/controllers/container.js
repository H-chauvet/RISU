const { db } = require('../middleware/database')

exports.getContainer = id => {
  return db.Container.findMany({
    where: {
      id: id
    }
  })
}

exports.deleteContainer = id => {
  return db.Container.delete({
    where: {
      id: id
    }
  })
}

exports.createContainer = container => {
  container.price = parseFloat(container.price)
  return db.Container.create({
    data: container
  })
}

exports.updateContainer = (id, container) => {
  container.price = parseFloat(container.price)
  return db.Container.update({
    where: {
      id: id
    },
    data: container
  })
}

exports.getAllContainers = async () => {
  try {
    const users = await db.Container.findMany();
    return users;
  } catch (error) {
    console.error('Error retrieving users:', error);
    throw new Error('Failed to retrieve users');
  }
};

exports.createContainer2 = container => {
  container.price = parseFloat(container.price)
  return db.Container.create({
    data: container
  })
}