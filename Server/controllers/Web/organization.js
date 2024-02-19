const { db } = require("../../middleware/database");

exports.createOrganization = (organization) => {
    return db.Organization.create({
      data: organization,
    });
};

exports.getAllOrganizations = async () => {
    try {
      return db.Organization.findMany();
    } catch (error) {
      console.error("Error retrieving containers:", error);
      throw new Error("Failed to retrieve containers");
    }
};

exports.getOrganizationById = (id) => {
  return db.Organization.findUnique({
    where: { id: id },
    include: {
      containers: {
        include: {
          items: true,
        },
      },
    },
  })
}