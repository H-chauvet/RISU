const { db } = require("../middleware/database");

exports.registerMessage = (data) => {
  return db.Contact.create({
    data: data,
  });
};
