const { db } = require('../../middleware/database')

exports.getAllItem = containerId => {
  return db.Items_Web.findMany({
    where: {
        containerId: containerId
    }
  })
}

exports.getItem = id => {
  return db.Items_Web.findMany()
}

exports.deleteItem = id => {
  return db.Items_Web.delete({
    where: {
      id: id
    }
  })
}

exports.createItem = item => {
  item.price = parseFloat(item.price)
  return db.Items_Web.create({
    data: item
  })
}

exports.updateItem = (id, item) => {
  item.price = parseFloat(item.price);
  return db.Items_Web.update({
    where: {
      id: id,
    },
    data: item,
  });
};