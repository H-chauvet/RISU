// Exemple de jest.setup.js
const { PrismaClient } = require("@prisma/client");
const db = new PrismaClient();

// Fermez le client Prisma après les tests
afterAll(async () => {
  await db.$disconnect();
});
