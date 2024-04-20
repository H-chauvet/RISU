const { db } = require("../middleware/database");
const bcrypt = require("bcrypt");

exports.createFixtures = async () => {
  try {
    const notification1 = await db.Notifications_Mobile.create({
      data: {
        favoriteItemsAvailable: true,
        endOfRenting: true,
        newsOffersRisu: true,
      },
    });
    const notification2 = await db.Notifications_Mobile.create({
      data: {
        favoriteItemsAvailable: true,
        endOfRenting: true,
        newsOffersRisu: true,
      },
    });
    const itemCategory1 = await db.Item_Category.create({
      data: {
        name: "Sport",
      },
    });
    const itemCategory2 = await db.Item_Category.create({
      data: {
        name: "Plage",
      },
    });
    const container = await db.Containers.create({
      data: {
        id: 1,
        city: "Nantes",
        address: "Rue d'Alger",
        latitude: 47.210537, // Epitech Nantes
        longitude: -1.566808,
        saveName: "container",
        containerMapping: "",
        price: 0,
        width: 12,
        height: 5,
        items: {
          create: [
            {
              name: "Ballon de volley",
              price: 3,
              available: true,
              categories: {
                connect: [{ id: 1 }, { id: 2 }],
              },
            },
            {
              name: "Raquette de tennis",
              price: 6,
              available: false,
              categories: {
                connect: [{ id: 1 }],
              },
            },
            {
              name: "Jeux de badminton",
              price: 16,
              available: true,
              categories: {
                connect: [{ id: 2 }],
              },
            },
          ],
        },
      },
    });

    const emptyContainer = await db.Containers.create({
      data: {
        id: 2,
        city: "Saint Brévin l'Océan",
        address: "Boulevard de l'Océan",
        latitude: 47.232375,
        longitude: -2.179429,
        saveName: "emptyContainer",
        containerMapping: "",
        price: 0,
        width: 12,
        height: 5,
        items: {
          create: [],
        },
      },
    });
    if (
      !(await db.User_Mobile.findUnique({
        where: { email: "admin@gmail.com" },
      }))
    )
      await db.User_Mobile.create({
        data: {
          email: "admin@gmail.com",
          firstName: "admin",
          lastName: "admin",
          password: bcrypt.hashSync("admin", 12),
          mailVerification: true,
          notificationsId: notification1.id,
        },
        include: {
          Notifications: true,
        },
      });
    if (
      !(await db.User_Mobile.findUnique({ where: { email: "user@gmail.com" } }))
    )
      await db.User_Mobile.create({
        data: {
          email: "user@gmail.com",
          firstName: "user",
          lastName: "user",
          password: bcrypt.hashSync("user", 12),
          mailVerification: true,
          notificationsId: notification2.id,
        },
        include: {
          Notifications: true,
        },
      });
  } catch (err) {
    console.error(err.message);
  }
};
