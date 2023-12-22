const { db } = require('../middleware/database')

exports.getAllObject = containerId => {
  return db.Object.findMany({
    where: {
        containerId: containerId
    }
  })
}

exports.getObject = id => {
  return db.Object.findMany()
}


exports.createObject2 = object => {
  object.price = 10;
  return db.Object.create({
    data: object
  })
}

exports.deleteObject = id => {
  return db.Object.delete({
    where: {
      id: id
    }
  })
}

exports.createObject = object => {
  object.price = parseFloat(object.price)
  object.height = parseFloat(object.height)
  object.width = parseFloat(object.width)
  return db.Object.create({
    data: object
  })
}

exports.createObject2 = object => {
  object.price = parseFloat(object.price)
  return db.Object.create({
    data: object
  })
}