const express = require("express");
const router = express.Router();

const passport = require("passport");
const organizationCtrl = require("../../controllers/Web/organization");
const jwtMiddleware = require("../../middleware/jwt");

router.post("/create", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
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
    throw new Error("Unauthorized");
  }
  const id = parseInt(req.params.id);
  try {
    const { contactInformation } = req.body;

    if (!contactInformation) {
      res.status(400).json({
        error:
          "Email and at least one of contactInformation or type are required",
      });
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(id);
    if (!existingOrganization) {
      res.status(404).json({ error: "Organization not found" });
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
    throw new Error("Unauthorized");
  }
  try {
    const id = parseInt(req.params.id);
    const { type } = req.body;

    if (!type) {
      res.status(400).json({
        error: "Email and at least one of type or type are required",
      });
      return;
    }

    const existingOrganization = await organizationCtrl.getOrganizationById(id);
    if (!existingOrganization) {
      res.status(404).json({ error: "Organization not found" });
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
