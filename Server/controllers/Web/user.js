const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { db } = require("../../middleware/database");
const uuid = require("uuid");
const transporter = require("../../middleware/transporter");

/**
 * Find user by email
 *
 * @param {string} email of the user
 * @returns user finded by email
 */
exports.findUserByEmail = async (email) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        email,
      },
    });
  } catch (err) {
    throw "Something happen while retrieving user";
  }
};

/**
 * Find user by uuid
 *
 * @param {string} uuid of the user
 * @returns user finded by uuid
 */
exports.findUserByUuid = async (uuid) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        uuid,
      },
    });
  } catch (err) {
    throw "Something happen while retrieving user";
  }
};

/**
 * Find user by id
 *
 * @param {number} id of the user
 * @returns user finded by id
 */
exports.findUserById = async (id) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        id,
      },
    });
  } catch (err) {
    throw "Something happen while retrieving user";
  }
};

/**
 * Delete a user
 *
 * @param {string} email of user to delete
 * @returns user deleted
 */
exports.deleteUser = async (email) => {
  try {
    return await db.User_Web.delete({
      where: {
        email,
      },
    });
  } catch (err) {
    throw "Something happen while deleting user";
  }
};

/**
 * Create new user
 *
 * @param {*} user information
 * @returns created user object
 */
exports.registerByEmail = async (user) => {
  try {
    user.password = bcrypt.hashSync(user.password, 12);
    user.uuid = uuid.v4();
    let data;
    await db.Organization.findUnique({
      where: {
        name: user.company,
      },
    }).then(async (org) => {
      if (org === null) {
        await db.Organization.create({
          data: {
            name: user.company,
            containers: undefined,
          },
        }).then(async (org) => {
          user.organizationId = org.id;
          data = await db.User_Web.create({
            data: user,
          });
        });
      } else {
        user.organizationId = org.id;
        data = await db.User_Web.create({
          data: user,
        });
      }
    });
    return data;
  } catch (err) {
    throw "Something happen while registering user";
  }
};

/**
 * Define the mail object for register confirmation and call associate middleware
 *
 * @param {string} email of the receiver
 */
exports.registerConfirmation = async (email) => {
  try {
    let generatedUuid = "";
    this.findUserByEmail(email).then((user) => {
      generatedUuid = user.uuid;
      let mail = {
        from: "risu.epitech@gmail.com",
        to: email,
        subject: "Confirmation d'inscription",
        html:
          '<p>Bonjour, merci de vous être inscrit sur notre site, Veuillez cliquer sur le lien suivant pour confirmer votre inscription: <a href="http://51.77.215.103/#/confirmed-user/' +
          generatedUuid +
          '">Confirmer</a>' +
          "</p>",
      };
      transporter.sendMail(mail);
    });
  } catch (err) {
    throw "Something happen while sending confirmation mail";
  }
};

/**
 * Set confirmed at true
 *
 * @param {string} uuid
 * @returns user object
 */
exports.confirmedRegister = async (uuid) => {
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
    throw "Something happen while updating user";
  }
};

/**
 * Authentification of an user
 *
 * @param {*} user
 * @returns user object logged in
 */
exports.loginByEmail = async (user) => {
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
    throw "Something happen while logging user";
  }
};

/**
 * Update password
 *
 * @param {*} user
 * @returns user object with updated password
 */
exports.updatePassword = async (user) => {
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
    throw "Something happen while updating password";
  }
};

/**
 * Define the mail object for password change and call associate middleware
 *
 * @param {string} email of the receiver
 */
exports.forgotPassword = async (email) => {
  try {
    let generatedUuid = "";
    this.findUserByEmail(email).then((user) => {
      generatedUuid = user.uuid;
      let mail = {
        from: "risu.epitech@gmail.com",
        to: email,
        subject: "Réinitialisation de mot de passe",
        html:
          '<p>Bonjour, pour réinitialiser votre mot de passe, Veuillez cliquer sur le lien suivant: <a href="http://51.77.215.103/#/password-change/' +
          generatedUuid +
          '">Réinitialiser le mot de passe</a>' +
          "</p>",
      };
      transporter.sendMail(mail);
    });
  } catch (err) {
    throw "Something happen while sending mail";
  }
};

/**
 * Retrieve every web users of the database
 *
 * @returns every user found
 */
exports.getAllUsers = async () => {
  try {
    const users = await db.User_Web.findMany();
    return users;
  } catch (error) {
    console.error("Error retrieving users:", error);
    throw "Failed to retrieve users";
  }
};

/**
 * Find user details by email (including first name and last name)
 *
 * @param {string} email of the user
 * @returns user details (including first name and last name)
 */
exports.findUserDetailsByEmail = async (email) => {
  try {
    return await db.User_Web.findUnique({
      where: {
        email,
      },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        createdAt: true,
        company: true,
        email: true,
        organizationId: true,
        organization: true,
      },
    });
  } catch (err) {
    throw "Something happen while retrieving user";
  }
};

/**
 * Update firstName and LastName
 *
 * @param {*} user
 * @returns user object with updated firstName and lastName
 */
exports.updateName = async (user) => {
  try {
    return await db.User_Web.update({
      where: {
        email: user.email,
      },
      data: {
        firstName: user.firstName,
        lastName: user.lastName,
      },
    });
  } catch (err) {
    throw "Something happen while updating user";
  }
};

/**
 * Update organization
 *
 * @param {*} user
 * @returns user object with updated organization
 */
exports.updateOrganization = async (user) => {
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
    throw "Something happen while updating user";
  }
};

/**
 * Update mail
 *
 * @param {*} user
 * @returns user object with updated mail
 */
exports.updateMail = async (user) => {
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
    throw "Something happen while updating user";
  }
};

/**
 * Update company
 *
 * @param {*} user
 * @returns user object with updated company
 */
exports.updateCompany = async (user) => {
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
    throw "Something happen while updating user";
  }
};

/**
 * Update company
 *
 * @param {*} user
 * @returns user object with updated company
 */
exports.updateUserPassword = async (user) => {
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
    throw "Something happen while updating user";
  }
};

/**
 * Get user information from token stored in the request
 *
 * @param {*} req the request
 * @returns user object
 */
exports.getUserFromToken = (req) => {
  const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);
    return userCtrl.findUserByEmail(decodedToken.userMail);
}
