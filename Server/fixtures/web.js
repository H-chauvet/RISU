const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const user = await db.User_Web.create({
      data: {
        firstName: "Admin",
        lastName: "Risu",
        email: "risu.admin@gmail.com",
        confirmed: true,
        password: bcrypt.hashSync("admin", 12),
        company: "Risu",
      },
    });
  } catch (err) {
    console.error(err.message);
  }
  const emptyTicket = await db.Tickets.create({
    data: {
      id: 1,
      content: "Ceci est un ticket test",
      title: "Ticket de Henri",
      creatorId: "",
      assignedId: "",
    },
  });
};
