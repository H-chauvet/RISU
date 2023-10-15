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

exports.updateContainer = container => {
  return db.Container.update({
    where: {
      id: container.id
    },
    data: {
      name: container.name
    }
  })
}
