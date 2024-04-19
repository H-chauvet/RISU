const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const organization = await db.Organization.create({
      data: {
        name: "Risu",
        type: "Entreprise",
        contactInformation: "Contact Information Example",
        affiliate: {
          create: [
            {
              firstName: "Louis",
              lastName: "Maestre",
              email: "louis.maestre@hotmail.fr",
              confirmed: true,
              password: bcrypt.hashSync("louismaestre", 12),
              company: "Risu",
            },
          ],
        },
        containers: {
          create: [
            {
              id: 3,
              city: "Paris",
              address: "4 rue George",
              items: {
                create: [
                  {
                    id: 5,
                    name: "Ballon de foot",
                    price: 10,
                    available: true,
                    category: "sport",
                  },
                  {
                    id: 6,
                    name: "Ballon de volley",
                    price: 20,
                    available: false,
                    category: "plage",
                  },
                ],
              },
            },
            {
              id: 4,
              city: "Nantes",
              address: "8 rue George",
              items: {
                create: [
                  {
                    id: 7,
                    name: "Ballon de foot",
                    price: 10,
                    available: true,
                    category: "sport",
                  },
                  {
                    id: 8,
                    name: "Ballon de volley",
                    price: 20,
                    available: false,
                    category: "plage",
                  },
                ],
              },
            },
          ],
        },
      },
    });
    const user = await db.User_Web.create({
      data: {
        firstName: "Admin",
        lastName: "Risu",
        email: "risu.admin@gmail.com",
        confirmed: true,
        password: bcrypt.hashSync("adminrisu", 12),
      },
    });
  } catch (err) {
    console.error(err.message);
  }
};