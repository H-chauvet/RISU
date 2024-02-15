const { db } = require('../../middleware/database')

exports.getAllItem = containerId => {
  return db.Item.findMany({
    where: {
        containerId: containerId
    }
  })
}

exports.getItemFromId = (id) => {
  return db.Item.findUnique({
    where: { id: id }
  })
}

exports.getItems = () => {
  return db.Item.findMany()
}

exports.deleteItem = id => {
  return db.Item.delete({
    where: {
      id: id
    }
  })
}

exports.createItem = item => {
  item.price = parseFloat(item.price)
  return db.Item.create({
    data: item
  })
}

exports.updateItem = (id, item) => {
  item.price = parseFloat(item.price);
  return db.Item.update({
    where: {
      id: id,
    },
    data: item,
  });
};

exports.getAvailableItemsCount = (containerId) => {
  return db.Items.count({
    where: { containerId: containerId },
    select: { available: true }
  })
}