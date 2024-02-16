const { db } = require('../../middleware/database')

exports.getAllItem = (containerId) => {
  return db.Item.findMany({
    where: {
      containerId: containerId,
    },
  });
};

exports.getItemFromId = (id) => {
  intId = parseInt(id)
  return db.Item.findUnique({
    where: { id: intId }
  })
}

exports.getItems = () => {
  return db.Item.findMany()
}

exports.deleteItem = (id) => {
  return db.Item.delete({
    where: {
      id: id,
    },
  });
};

exports.createItem = (item) => {
  item.price = parseFloat(item.price);
  return db.Item.create({
    data: item,
  });
};

exports.updateItem = (id, item) => {
  intId = parseInt(id)
  item.price = parseFloat(item.price);
  return db.Item.update({
    where: {
      id: intId,
    },
    data: item,
  });
};

exports.getAvailableItemsCount = (containerId) => {
  return db.Item.count({
    where: { containerId: containerId },
    select: { available: true }
  })
}
