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
        name: "sports",
      },
    });
    const itemCategory2 = await db.Item_Category.create({
      data: {
        name: "beach",
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
        price: 500.5,
        width: 12,
        height: 5,
        items: {
          create: [
            {
              id: 1,
              name: "Ballon de volley",
              price: 0.5,
              available: true,
              rating: 4.5,
              categories: {
                connect: [{ id: 1 }, { id: 2 }],
              },
            },
            {
              id: 2,
              name: "Raquette",
              price: 1.0,
              available: true,
              rating: 4.0,
              categories: {
                connect: [{ id: 1 }],
              },
            },
            {
              id: 3,
              name: "Ballon de football",
              price: 0.75,
              available: false,
              categories: {
                connect: [{ id: 2 }],
              },
            },
            {
              id: 4,
              name: "Freesbee",
              price: 1.5,
              available: true,
              categories: {
                connect: [{ id: 1 }],
              },
            },
          ],
        },
      },
    });

    const emptyContainer = await db.Containers.create({
      data: {
        id: 2,
        city: "Saint-Brévin",
        address: "Boulevard de l'Océan",
        latitude: 47.232375,
        longitude: -2.179429,
        saveName: "emptyContainer",
        containerMapping: "",
        price: 300.1,
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
          itemOpinions: {
            create: [
              {
                itemId: 1,
                date: new Date(),
                note: "5",
                comment: "Joli ballon.",
              },
            ],
          },
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
          itemOpinions: {
            create: [
              {
                itemId: 1,
                date: new Date(),
                note: "4",
                comment: "Ballon de qualité.",
              },
            ],
          },
        },
        include: {
          Notifications: true,
        },
      });
    if (
      !(await db.User_Mobile.findUnique({
        where: { email: "tanguybell@gmail.com" },
      }))
    )
      await db.User_Mobile.create({
        data: {
          id: "42",
          email: "tanguybell@gmail.com",
          firstName: "Armand",
          lastName: "Lartam",
          password: bcrypt.hashSync("12345678", 12),
          mailVerification: true,
          notificationsId: notification2.id,
          locations: {
            create: [
              {
                itemId: 3,
                duration: 48,
                price: 100,
              },
            ],
          },
        },
        include: {
          Notifications: true,
        },
      });
    const emptyTicket1 = await db.Tickets.create({
      data: {
        id: 2,
        content: "Vous êtes super !",
        title: "Coucou !",
        creatorId: "42",
        assignedId: "",
        chatUid: "1",
      },
    });
  } catch (err) {
    console.error(err.message);
  }
};
