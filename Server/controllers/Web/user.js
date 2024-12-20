const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { db } = require("../../middleware/database");
const uuid = require("uuid");
const transporter = require("../../middleware/transporter");
const jwtMiddleware = require("../../middleware/jwt");

/**
 * Find user by email
 *
 * @param {string} email of the user
 * @throws {Error} with a specific message to find the problem
 * @returns user finded by email
 */
exports.findUserByEmail = async (res, email) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        email,
      },
    });
  } catch (err) {
    console.log("err: " + err);
    throw res.__("errorOccurred");
  }
};

/**
 * Find user by uuid
 *
 * @param {string} uuid of the user
 * @throws {Error} with a specific message to find the problem
 * @returns user finded by uuid
 */
exports.findUserByUuid = async (res, uuid) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        uuid,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Find user by id
 *
 * @param {number} id of the user
 * @throws {Error} with a specific message to find the problem
 * @returns user finded by id
 */
exports.findUserById = async (res, id) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        id,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Delete a user
 *
 * @param {string} email of user to delete
 * @throws {Error} with a specific message to find the problem
 * @returns user deleted
 */
exports.deleteUser = async (res, email) => {
  try {
    return await db.User_Web.delete({
      where: {
        email,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Create new user
 *
 * @param {*} user information
 * @throws {Error} with a specific message to find the problem
 * @returns created user object
 */
exports.registerByEmail = async (res, user) => {
  try {
    user.password = bcrypt.hashSync(user.password, 12);
    user.uuid = uuid.v4();
    let data;
    data = await db.User_Web.create({
      data: user,
    });

    return data;
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

exports.addCompanyToUser = async (res, user, company, manager) => {
  try {
    company = JSON.parse(company);

    await db.User_Web.update({
      where: {
        id: user.id,
      },
      data: {
        company: company.name,
        organizationId: company.id,
        manager: manager,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Define the mail object for register confirmation and call associate middleware
 *
 * @param {string} email of the receiver
 * @throws {Error} with a specific message to find the problem
 */
exports.registerConfirmation = async (res, email) => {
  try {
    let generatedUuid = "";
    this.findUserByEmail(res, email).then((user) => {
      generatedUuid = user.uuid;
      let mail = {
        from: "risu.epitech@gmail.com",
        to: email,
        subject: "Confirmation d'inscription",
        html:
          '<p>Bonjour, merci de vous être inscrit sur notre site, Veuillez cliquer sur le lien suivant pour confirmer votre inscription: <a href="http://risu-app.fr/#/confirmed-user/' +
          generatedUuid +
          '">Confirmer</a>' +
          "</p>",
      };
      transporter.sendMail(mail);
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Set confirmed at true
 *
 * @param {string} uuid
 * @throws {Error} with a specific message to find the problem
 * @returns user object
 */
exports.confirmedRegister = async (res, uuid) => {
  try {
    return await db.User_Web.update({
      where: {
        uuid: uuid,
      },
      data: {
        confirmed: true,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Authentification of an user
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object logged in
 */
exports.loginByEmail = async (res, user) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        email: user.email,
      },
    }).then((findUser) => {
      if (!bcrypt.compareSync(user.password, findUser.password)) {
        throw new Error("Invalid password");
      }

      return findUser;
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update password
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated password
 */
exports.updatePassword = async (res, user) => {
  try {
    user.password = bcrypt.hashSync(user.password, 12);
    return await db.User_Web.update({
      where: {
        uuid: user.uuid,
      },
      data: {
        password: user.password,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Define the mail object for password change and call associate middleware
 *
 * @param {string} email of the receiver
 * @throws {Error} with a specific message to find the problem
 */
exports.forgotPassword = async (res, email) => {
  try {
    let generatedUuid = "";
    this.findUserByEmail(res, email).then((user) => {
      generatedUuid = user.uuid;
      let mail = {
        from: "risu.epitech@gmail.com",
        to: email,
        subject: "Réinitialisation de mot de passe",
        html:
          '<p>Bonjour, pour réinitialiser votre mot de passe, Veuillez cliquer sur le lien suivant: <a href="http://risu-app.fr/#/password-change/' +
          generatedUuid +
          '">Réinitialiser le mot de passe</a>' +
          "</p>",
      };
      transporter.sendMail(mail);
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Retrieve every web users of the database
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every user found
 */
exports.getAllUsers = async (res) => {
  try {
    const users = await db.User_Web.findMany();
    return users;
  } catch (error) {
    console.error("Error retrieving users:", error);
    throw res.__("errorOccurred");
  }
};

/**
 * Find user details by email (including first name and last name)
 *
 * @param {string} email of the user
 * @throws {Error} with a specific message to find the problem
 * @returns user details (including first name and last name)
 */
exports.findUserDetailsByEmail = async (res, email) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        email,
      },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        language: true,
        createdAt: true,
        company: true,
        email: true,
        organizationId: true,
        organization: true,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update firstName and LastName
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated firstName and lastName
 */
exports.updateName = async (res, currUser, newUser) => {
  try {
    return await db.User_Web.update({
      where: {
        email: currUser.email,
      },
      data: {
        firstName: newUser.firstName ?? currUser.firstName,
        lastName: newUser.lastName ?? currUser.lastName,
        language: newUser.language ?? currUser.language,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update organization
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated organization
 */
exports.updateOrganization = async (res, user) => {
  try {
    return await db.User_Web.update({
      where: {
        email: user.email,
      },
      data: {
        organizationId: user.id,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update mail
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated mail
 */
exports.updateMail = async (res, user) => {
  try {
    return await db.User_Web.update({
      where: {
        email: user.oldMail,
      },
      data: {
        email: user.newMail,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update company
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated company
 */
exports.updateCompany = async (res, user) => {
  try {
    return await db.User_Web.update({
      where: {
        email: user.email,
      },
      data: {
        company: user.company,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Update company
 *
 * @param {*} user
 * @throws {Error} with a specific message to find the problem
 * @returns user object with updated company
 */
exports.updateUserPassword = async (res, user) => {
  try {
    user.password = bcrypt.hashSync(user.password, 12);
    return await db.User_Web.update({
      where: {
        email: user.email,
      },
      data: {
        password: user.password,
      },
    });
  } catch (err) {
    throw res.__("errorOccurred");
  }
};

/**
 * Get user information from token stored in the request
 *
 * @param {*} req the request
 * @throws {Error} with a specific message to find the problem
 * @returns user object
 */
exports.getUserFromToken = (res, req) => {
  const token = req.headers.authorization.split(" ")[1];
  const decodedToken = jwtMiddleware.decodeToken(token);
  return userCtrl.findUserByEmail(res, decodedToken.userMail);
};

exports.getUsersFromOrganizationId = async (res, organizationId) => {
  try {
    return await db.User_Web.findMany({
      where: {
        organizationId: parseInt(organizationId),
      },
    });
  } catch (err) {
    throw res.__("errorOccured");
  }
};
