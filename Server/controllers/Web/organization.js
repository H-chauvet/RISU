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

exports.updateName = organization => {
  return db.Organization.update({
    where: {
      id: organization.id,
    },
    data: {
      name: organization.name,
    },
  });
};

exports.updateContactInformation = organization => {
  return db.Organization.update({
    where: {
      id: organization.id,
    },
    data: {
      contactInformation: organization.contactInformation,
    },
  });
};

exports.updateType = organization => {
  return db.Organization.update({
    where: {
      id: organization.id,
    },
    data: {
      type: organization.type,
    },
  });
};