const express = require("express");

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const itemCtrl = require("../../controllers/Common/items")
const favoriteCtrl = require("../../controllers/Mobile/favorites")
const jwtMiddleware = require('../../middleware/Mobile/jwt')
const imagesCtrl = require('../../controllers/Common/images')
const languageMiddleware = require("../../middleware/language");

router.post(
  "/:itemId",
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
      if (!req.params.itemId) {
        return res.status(401).send(res.__("missingItemId"));
      }
      const item = await itemCtrl.getItemFromId(res, req.params.itemId);
      if (!item) {
        return res.status(404).send(res.__("itemNotFound"));
      }
      const favorite = await favoriteCtrl.checkFavorite(user.id, item.id);
      if (favorite) {
        return res.status(403).send(res.__("favExist"));
      }
      await favoriteCtrl.createFavoriteItem(user.id, item.id);

      return res.status(201).send(res.__("favAdded"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.get(
  "/",
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
      const favorites = await favoriteCtrl.getUserFavorites(user.id);
      if (!favorites) {
        return res.status(404).send(res.__("favNotFound"));
      }
			for (const favorite of favorites) {
				const imageUrl = await imagesCtrl.getItemImagesUrl(favorite.item.id, 0);
				favorite.imageUrl = imageUrl[0];
			}
			return res.status(200).json({ favorites })
		} catch (err) {
			console.error(err.message)
			return res.status(500).send(res.__("errorOccured"))
		}
	}
)

router.get(
  "/:itemId",
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
      if (!req.params.itemId) {
        return res.status(400).send(res.__("missingItemId"));
      }
      const item = await itemCtrl.getItemFromId(res, req.params.itemId);
      if (!item) {
        return res.status(404).send(res.__("itemNotFound"));
      }
      const favorite = await favoriteCtrl.checkFavorite(user.id, item.id);

      return res.status(200).json(favorite);
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.delete(
  "/:itemId",
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
      if (!req.params.itemId) {
        return res.status(400).send(res.__("missingItemId"));
      }
      const item = await itemCtrl.getItemFromId(res, req.params.itemId);
      if (!item) {
        return res.status(404).send(res.__("itemNotFound"));
      }
      const favorite = await favoriteCtrl.getItemFavorite(user.id, item.id);
      if (!favorite) {
        return res.status(404).send(res.__("favNotFound"));
      }
      await favoriteCtrl.deleteFavorite(favorite.id);

      return res.status(200).send(res.__("favDeleted"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

module.exports = router;
