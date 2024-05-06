const express = require("express");
const router = express.Router();

const passport = require("passport");
const organizationCtrl = require("../../controllers/Web/organization");
const userCtrl = require("../../controllers/Web/user");
const jwtMiddleware = require("../../middleware/jwt");

router.post(
  "/create",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization);
    } catch (err) {
      res.status(401);
      throw new Error("Unauthorized");
    }
    try {
      const { name, type, affiliate, containers, contactInformation } =
        req.body;
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
  }
);

router.post(
  "/update-information/:id",
  jwtMiddleware.checkToken,
  async (req, res, next) => {
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

      const existingUser = await organizationCtrl.getOrganizationById(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await organizationCtrl.updateContactInformation({
        id,
        contactInformation,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  "/update-type/:id",
  jwtMiddleware.checkToken,
  async (req, res, next) => {
    try {
      const id = parseInt(req.params.id);
      const { type } = req.body;

      if (!type) {
        res.status(400).json({
          error: "Email and at least one of type or type are required",
        });
        return;
      }

      const existingUser = await organizationCtrl.getOrganizationById(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await organizationCtrl.updateType({
        id,
        type,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

module.exports = router;
