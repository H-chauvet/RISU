const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const userWeb = await db.User_Web.create({
      data: {
        id: 1,
        uuid: "123456",
        email: "louis@gmail.com",
        firstName: "louis",
        lastName: "louis",
        password: bcrypt.hashSync("louis", 12),
        confirmed: true,
        role: "user",
        manager: true,
      },
    });

    const adminWeb = await db.User_Web.create({
      data: {
        id: 2,
        uuid: "1234567",
        email: "michel.lefevre@gmail.com",
        firstName: "Michel",
        lastName: "Lefevre",
        password: bcrypt.hashSync("admin", 12),
        confirmed: true,
        role: "admin",
      },
    });

    const container_web = await db.Containers.create({
      data: {
        id: 3,
        price: 560.5,
        city: "Nantes 2.0",
        address: "Rue d'Alger",
        latitude: 0.0,
        longitude: 0.0,
        saveName: "container",
        containerMapping: "",
        price: 500.5,
        width: 12,
        height: 5,
        items: {
          create: [
            {
              id: 5,
              name: "Ballon de volley",
              price: 0.5,
              available: true,
              category: "Plage",
              status: 'GOOD',
            },
            {
              id: 6,
              name: "Raquette",
              price: 1.0,
              available: true,
              category: "Tennis",
              status: 'WORN',
            },
            {
              id: 7,
              name: "Ballon de football",
              price: 0.75,
              available: false,
              category: "Foot",
              status: 'WORN',
            },
          ],
        },
      },
    });

    const organization = await db.Organization.create({
      data: {
        id: 1,
        name: "Riri",
        affiliate: {
          connect: { id: userWeb.id },
        },
        containers: {
          connect: { id: container_web.id },
        },
      },
    });
  } catch (err) {
    console.error(err.message);
  }

  try {
    const user2 = await db.User_Web.create({
      data: {
        firstName: "Henri",
        lastName: "Chauvet",
        uuid: "12345",
        email: "henri@risu.com",
        confirmed: true,
        password: bcrypt.hashSync("henri", 12),
        company: "Risu",
      },
    });
  } catch (err) {
    console.error(err.message);
  }
};
