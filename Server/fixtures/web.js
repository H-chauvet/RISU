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
                  { name: "Ballon de foot", price: 10, available: true },
                  {
                    name: "Ballon de volley",
                    price: 20,
                    available: false,
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
                  { name: "Ballon de foot", price: 10, available: true },
                  {
                    name: "Ballon de volley",
                    price: 20,
                    available: false,
                  },
                ],
              },
            },
          ],
        },
      },
    });
  } catch (err) {
    console.error(err.message);
  }
};