const express = require("express");
const router = express.Router();
const organizationCtrl = require("../../controllers/Web/organization");

router.get("/get/:id", async function (req, res, next) {
    try {
        const id = req.params.id;
        if (!id) {
            res.status(400);
            throw new Error("id is required");
        }
        const organization = await organizationCtrl.getOrganizationById(parseInt(id));
        res.status(200).json(organization);
        } catch (err) {
        next(err);
    }
});

router.post("/create", async function (req, res, next) {
    // try {
    //   jwtMiddleware.verifyToken(req.headers.authorization);
    // } catch (err) {
    //   res.status(401);
    //   throw new Error("Unauthorized");
    // }
    try {
      const { name, type, affiliate, containers, contactInformation } = req.body;
      const organization = await organizationCtrl.createOrganization({
        name,
        type,
        affiliate,
        containers,
        contactInformation
      });
      res.status(200).json(organization);
    } catch (err) {
      next(err);
    }
});

router.get("/listAll", async function (req, res, next) {
    try {
        const organization = await organizationCtrl.getAllOrganizations();
        res.status(200).json({ organization });
    } catch (err) {
        next(err);
    }
});

module.exports = router;