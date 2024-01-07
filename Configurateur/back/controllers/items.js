const { db } = require('../middleware/database')

exports.getAllItem = containerId => {
  return db.Item.findMany({
    where: {
        containerId: containerId
    }
  })
}

exports.getItem = id => {
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