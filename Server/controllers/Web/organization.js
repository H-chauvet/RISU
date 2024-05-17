const { db } = require("../../middleware/database");

/**
 * Created organization
 *
 * @param {*} organization
 * @returns created organization
 */
exports.createOrganization = (organization) => {
    return db.Organization.create({
      data: organization,
    });
};

/**
 * Display all organization
 *
 * @param {*} organization
 * @returns Display all organization
 */
exports.getAllOrganizations = async () => {
    try {
      return db.Organization.findMany();
    } catch (error) {
      console.error("Error retrieving containers:", error);
      throw new Error("Failed to retrieve containers");
    }
};

/**
 * Display organization by id
 *
 * @param {*} organization
 * @returns Display organization by id
 */
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

/**
 * Update organization name
 *
 * @param {*} organization
 * @returns Updated name of the organization
 */
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

/**
 * Update organization contact information
 *
 * @param {*} organization
 * @returns Updated contact information of the organization
 */
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

/**
 * Update organization type
 *
 * @param {*} organization
 * @returns Updated type of the organization
 */
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
