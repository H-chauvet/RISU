const { db } = require("../../middleware/database");
const transporter = require("../../middleware/transporter");

/**
 * Created organization
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns created organization
 */
exports.createOrganization = async (res, organization) => {
  try {
    return await db.Organization.create({
      data: organization,
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};

/**
 * Display all organization
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns Display all organization
 */
exports.getAllOrganizations = async (res) => {
  try {
    return await db.Organization.findMany();
  } catch (error) {
    console.error("Error retrieving containers:", error);
    throw res.__("errorOccured");
  }
};

/**
 * Display organization by id
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns Display organization by id
 */
exports.getOrganizationById = async (res, id) => {
  try {
    id = parseInt(id);
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
    throw res.__("errorOccured");
  }
};

/**
 * Update organization name
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns Updated name of the organization
 */
exports.updateName = async (res, organization) => {
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
    throw res.__("errorOccured");
  }
};

/**
 * Update organization contact information
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns Updated contact information of the organization
 */
exports.updateContactInformation = async (res, organization) => {
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
    throw res.__("errorOccured");
  }
};

/**
 * Update organization type
 *
 * @param {*} organization
 * @throws {Error} with a specific message to find the problem
 * @returns Updated type of the organization
 */
exports.updateType = (res, organization) => {
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
    throw res.__("errorOccured");
  }
};

exports.inviteMember = (res, memberList, company) => {
  try {
    memberList = JSON.parse(memberList);
    company = JSON.parse(company);

    memberList.forEach((element) => {
      let mail = {
        from: "risu.epitech@gmail.com",
        to: element,
        subject: "Invitation",
        html:
          '<p>Bonjour, vous avez été invité à rejoindre une entreprise sur le site RISU. Afin de créer votre compte, veuillez cliquer sur le lien suivant: <a href="http://51.77.215.103/#/register/' +
          company.id +
          '">Inscription</a>' +
          "</p>",
      };
      transporter.sendMail(mail);
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};
