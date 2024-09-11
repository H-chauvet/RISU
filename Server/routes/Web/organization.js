const express = require("express");
const router = express.Router();

const passport = require("passport");
const organizationCtrl = require("../../controllers/Web/organization");
const jwtMiddleware = require("../../middleware/jwt");
const languageMiddleware = require("../../middleware/language");
const userCtrl = require("../../controllers/Web/user");

router.post("/create", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { name, type, affiliate, containers, contactInformation } = req.body;
    const organization = await organizationCtrl.createOrganization(res, {
      name,
      type,
      affiliate,
      containers,
      contactInformation,
    });
    res.status(200).json(organization);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-information/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  const id = parseInt(req.params.id);
  try {
    const { contactInformation } = req.body;

    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    if (!contactInformation) {
      res.status(400).send(res.__("missingMailContact"));
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(
      res,
      id
    );
    if (!existingOrganization) {
      res.status(404).send(res.__("organizationNotFound"));
      return;
    }

    const updatedOrganization = await organizationCtrl.updateContactInformation(
      res,
      {
        id,
        contactInformation,
      }
    );
    res.status(200).json(updatedOrganization);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-type/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const id = parseInt(req.params.id);
    const { type } = req.body;

    if (!type) {
      res.status(400).send(res.__("missingMailType"));
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(
      res,
      id
    );
    if (!existingOrganization) {
      res.status(404).send(res.__("organizationNotFound"));
      return;
    }

    const updatedOrganization = await organizationCtrl.updateType(res, {
      id,
      type,
    });
    res.status(200).json(updatedOrganization);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/invite-member", async (req, res) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const { teamMember, company } = req.body;
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const organization = await organizationCtrl.inviteMember(
      res,
      teamMember,
      company
    );
    res.status(200).send(organization);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/add-member", async (req, res) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const token = req.headers.authorization;
    const decodedToken = jwtMiddleware.decodeToken(token);
    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { companyId } = req.body;

    const company = await organizationCtrl.getOrganizationById(res, companyId);
    if (!company) {
      throw res.__("companyNotFound");
    }

    const userUpdated = await userCtrl.addCompanyToUser(
      res,
      user,
      JSON.stringify(company),
      false
    );
    res.status(200).send(userUpdated);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
