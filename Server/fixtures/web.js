const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const user = await db.User_Web.create({
      data: {
        firstName: "Admin",
        lastName: "Risu",
        uuid: "1234",
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
      creatorId: "1234",
      assignedId: "",
      chatUid: "1"
    },
  });
  const emptyTicke1 = await db.Tickets.create({
    data: {
      id: 2,
      content: "Ceci est un ticket test2",
      title: "Ticket de Henri",
      creatorId: "1234",
      assignedId: "",
      chatUid: "1"
    },
  });
  const emptyTicket2 = await db.Tickets.create({
    data: {
      id: 3,
      content: "Ceci est un ticket test3",
      title: "Ticket de Henri",
      creatorId: "",
      assignedId: "1234",
      chatUid: "1"
    },
  });
  const emptyTicket3 = await db.Tickets.create({
    data: {
      id: 4,
      content: "Ceci est un ticket test4",
      title: "Ticket de Henri",
      creatorId: "1234",
      assignedId: "",
      chatUid: "1"
    },
  });
};
