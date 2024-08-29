const express = require("express");
const router = express.Router();

const passport = require("passport");
const organizationCtrl = require("../../controllers/Web/organization");
const jwtMiddleware = require("../../middleware/jwt");
const languageMiddleware = require('../../middleware/language');
const userCtrl = require("../../controllers/Web/user");

router.post("/create", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const { name, type, affiliate, containers, contactInformation } = req.body;
    const organization = await organizationCtrl.createOrganization({
      name,
      type,
      affiliate,
      containers,
      contactInformation,
    });
    res.status(200).json(organization);
  } catch (err) {
    next(err);
  }
});

router.post("/update-information/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  const id = parseInt(req.params.id);
  try {
    const { contactInformation } = req.body;

    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    if (!contactInformation) {
      res.status(400).json({
        error: res.__('missingMailContact')
      });
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(id);
    if (!existingOrganization) {
      res.status(404).json({ error: res.__('organizationNotFound') });
      return;
    }

    const updatedOrganization = await organizationCtrl.updateContactInformation(
      {
        id,
        contactInformation,
      }
    );
    res.status(200).json(updatedOrganization);
  } catch (err) {
    next(err);
  }
});

router.post("/update-type/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const id = parseInt(req.params.id);
    const { type } = req.body;

    if (!type) {
      res.status(400).json({
        error: res.__('missingMailType'),
      });
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(id);
    if (!existingOrganization) {
      res.status(404).json({ error: res.__('organizationNotFound') });
      return;
    }

    const updatedOrganization = await organizationCtrl.updateType({
      id,
      type,
    });
    res.status(200).json(updatedOrganization);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
