const { db } = require("../../middleware/database");

/**
 * Retrieve all containers with specific datas
 * 
 * @throws {Error} with a specific message to find the problem
 * @returns every exitsting container
 */
exports.listContainers = async () => {
  try {
    return db.containers.findMany({
      select: {
        id: true,
        address: true,
        city: true,
        longitude: true,
        latitude: true,
        _count: {
          select: {
            items: {
              where: {
                available: true,
              },
            },
          }
        }
      },
    });
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw new Error("Failed to retrieve containers");
  }
};