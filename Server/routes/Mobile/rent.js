const express = require("express");
const PDFDocument = require("pdfkit");
const { createInvoice } = require("../../invoice/createInvoice");

const router = express.Router()
const passport = require('passport')
const rentCtrl = require("../../controllers/Mobile/rent")
const userCtrl = require("../../controllers/Mobile/user")
const itemCtrl = require("../../controllers/Common/items")
const imagesCtrl = require('../../controllers/Common/images')
const transporter = require('../../middleware/transporter')
const containerCtrl = require('../../controllers/Common/container')
const { formatDate, drawTable } = require('../../invoice/invoiceUtils');
const {
  sendEmailConfirmationLocation,
  sendInvoice,
} = require("../../invoice/rentUtils");
const jwtMiddleware = require("../../middleware/Mobile/jwt");
const languageMiddleware = require("../../middleware/language");

router.post(
  "/article",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      if (!req.body.itemId || req.body.itemId === "") {
        return res.status(400).send(res.__("missingItemId"));
      }

      const item = await itemCtrl.getItemFromId(res, parseInt(req.body.itemId));
      if (!item) {
        return res.status(404).send(res.__("itemNotFound"));
      }
      if (!req.body.duration || req.body.duration < 0) {
        return res.status(400).send(res.__("missingTime"));
      }
      if (!item.available) {
        return res.status(400).send(res.__("itemUnavailable"));
      }
      const locationPrice = item.price * req.body.duration;

      await itemCtrl.updateItem(res, item.id, {
        price: item.price,
        available: false,
      });

      const location = await rentCtrl.rentItem(
        locationPrice,
        item.id,
        user.id,
        parseInt(req.body.duration)
      );

      const container = await containerCtrl.getContainerById(
        res,
        item.containerId
      );

      sendEmailConfirmationLocation(
        user.email,
        new Date(),
        req.body.duration,
        container.address,
        container.city,
        item.name,
        locationPrice
      );

      var clientInfo = null;
      if (user.firstName == null || user.lastName == null) {
        clientInfo = "Non renseigné";
      } else {
        clientInfo = user.firstName + " " + user.lastName;
      }

      const invoice = {
        shipping: {
          name: clientInfo,
          address: "",
          city: "",
          state: "",
          country: "",
          postal_code: "",
        },
        items: [
          {
            item: item.name,
            description: "description",
            quantity: req.body.duration,
            amount: locationPrice,
          },
        ],
        subtotal: locationPrice,
        paid: 0,
        invoice_nr: "",
      };

      const invoiceData = await createInvoice(invoice);

      await rentCtrl.updateRentInvoice(location.id, invoiceData);

      return res
        .status(201)
        .json({ rentId: location.id, message: res.__("rentSaved") });
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.post(
  "/:locationId/invoice",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);

      const locationId = req.params.locationId;

      const location = await rentCtrl.getRentFromId(parseInt(locationId));

      if (!location) {
        return res.status(404).send(res.__("rentNotFound"));
      }

      if (!location.invoice) {
        return res.status(404).send(res.__("invoiceNotFound"));
      }

      await sendInvoice(location.invoice, user.email);

      return res.status(201).send(res.__("invoiceSent"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.get(
  "/listAll",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      const rentals = await rentCtrl.getUserRents(user.id);
      for (const rental of rentals) {
        const imageUrl = await imagesCtrl.getItemImagesUrl(res, rental.item.id, 0)
        rental.item.imageUrl = imageUrl[0]
      }
      return res.status(200).json({ rentals: rentals });
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.get(
  "/:rentId",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      if (!req.params.rentId || req.params.rentId == "") {
        return res.status(400).send(res.__("missingRentId"));
      }
      const rental = await rentCtrl.getRentFromId(parseInt(req.params.rentId));
      if (!rental) {
        return res.status(404).send(res.__("rentNotFound"));
      }
      if (rental.userId != req.user.id) {
        return res.status(403).send(res.__("wrongUserRent"));
      }
      const imageUrl = await imagesCtrl.getItemImagesUrl(res, rental.item.id, 0)
      rental.item.imageUrl = imageUrl[0]
      return res.status(200).json({ rental })
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.post(
  "/:rentId/return",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      if (!req.params.rentId || req.params.rentId == "") {
        return res.status(400).send(res.__("missingRentId"));
      }
      const rent = await rentCtrl.getRentFromId(parseInt(req.params.rentId));
      if (!rent) {
        return res.status(404).send(res.__("rentNotFound"));
      }
      if (rent.userId != req.user.id) {
        return res.status(403).send(res.__("wrongUserRent"));
      }
      await rentCtrl.returnRent(parseInt(req.params.rentId));
      return res.status(201).send(res.__("rentReturned"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

module.exports = router;
