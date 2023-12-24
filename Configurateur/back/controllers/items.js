const { db } = require('../middleware/database')

exports.getAllItem = containerId => {
  return db.Items.findMany({
    where: {
        containerId: containerId
    }
  })
}

exports.getItem = id => {
  return db.Items.findMany()
}

exports.deleteItem = id => {
  return db.Items.delete({
    where: {
      id: id
    }
  })
}

exports.createItem = item => {
  item.price = parseFloat(item.price)
  item.height = parseFloat(item.height)
  item.width = parseFloat(item.width)
  return db.Items.create({
    data: item
  })
}

exports.createItem2 = item => {
  item.price = parseFloat(item.price)
  return db.Items.create({
    data: item
  })
}