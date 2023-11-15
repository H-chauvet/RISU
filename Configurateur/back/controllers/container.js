const { db } = require('../middleware/database')

exports.getContainer = id => {
  return db.Container.findMany({
    where: {
      id: id
    }
  })
}

exports.getAllContainer = id => {
  return db.Container.findMany()
}


exports.createContainer2 = container => {
  container.price = 10;
  return db.Container.create({
    data: container
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
