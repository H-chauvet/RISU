const { db } = require("../../middleware/database");

/**
 * Created organization
 *
 * @param {*} organization
 * @returns created organization
 */
exports.createOrganization = async (organization) => {
  try {
    return await db.Organization.create({
      data: organization,
    });
  } catch (err) {
    throw "Something happen while creation organization";
  }
};

/**
 * Display all organization
 *
 * @param {*} organization
 * @returns Display all organization
 */
exports.getAllOrganizations = async () => {
  try {
    return await db.Organization.findMany();
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw "Failed to retrieve containers";
  }
};

/**
 * Display organization by id
 *
 * @param {*} organization
 * @returns Display organization by id
 */
exports.getOrganizationById = async (id) => {
  try {
    return await db.Organization.findUnique({
      where: { id: id },
      include: {
        containers: {
          include: {
            items: true,
          },
        },
      },
    });
  } catch (err) {
    throw "Something happen while retrieving organization";
  }
};

/**
 * Update organization name
 *
 * @param {*} organization
 * @returns Updated name of the organization
 */
exports.updateName = async (organization) => {
  try {
    return await db.Organization.update({
      where: {
        id: organization.id,
      },
      data: {
        name: organization.name,
      },
    });
  } catch (err) {
    throw "Something happen while updating organization's name";
  }
};

/**
 * Update organization contact information
 *
 * @param {*} organization
 * @returns Updated contact information of the organization
 */
exports.updateContactInformation = async (organization) => {
  try {
    return await db.Organization.update({
      where: {
        id: organization.id,
      },
      data: {
        contactInformation: organization.contactInformation,
      },
    });
  } catch (err) {
    throw "Something happen while updating organization's contact information";
  }
};

/**
 * Update organization type
 *
 * @param {*} organization
 * @returns Updated type of the organization
 */
exports.updateType = (organization) => {
  try {
    return db.Organization.update({
      where: {
        id: organization.id,
      },
      data: {
        type: organization.type,
      },
    });
  } catch (err) {
    throw "Something happen while updating organization's type";
  }
};
