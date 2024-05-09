const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const user = await db.User_Web.create({
      data: {
        firstName: "Michel",
        lastName: "Lefèvre",
        email: "michel.lefevre@gmail.com",
        confirmed: true,
        password: bcrypt.hashSync("admin", 12),
        role: "admin",
        company: "Risu",
      },
    });
  } catch (err) {
    console.error(err.message);
  }
};
