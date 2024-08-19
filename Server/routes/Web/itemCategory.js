const express = require("express");
const router = express.Router();

const itemCategoryCtrl = require('../../controllers/Common/itemCategory');
const jwtMiddleware = require('../../middleware/jwt');
const userCtrl = require("../../controllers/Web/user");
const languageMiddleware = require('../../middleware/language')

router.get("/", async function (req, res, next) {
  try {
    const itemCategories = await itemCategoryCtrl.getItemCategories();
    res.status(200).json(itemCategories);
  } catch (err) {
    next(err);
  }
});


router.get("/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)


    if (!req.params.id) {
      res.status(400);
      throw new Error(res.__('missingCategoryId'));
    }
    const itemCategory = await itemCategoryCtrl.getItemCategoryFromId(req.params.id);
    res.status(200).json(itemCategory);
  } catch (err) {
    next(err);
  }
});

router.post("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const name = req.body.name;
    if (!name) {
      res.status(400);
      throw new Error(res.__('missingName'));
    }

    const itemCategory = await itemCategoryCtrl.createItemCategory(name);
    res.status(200).json(name);
  } catch (err) {
    next(err);
  }
});

router.put("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const { id, name } = req.body;
    if (!id || !name) {
      res.status(400);
      throw new Error(res.__('missingIdName'));
    }

    const itemCategory = await itemCategoryCtrl.updateItemCategory(id, name);
    res.status(200).json(itemCategory);
  } catch (err) {
    next(err);
  }
});

router.delete("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const { id } = req.body;
    if (!id) {
      res.status(400);
      throw new Error(res.__('missingId'));
    }

    await itemCategoryCtrl.deleteItemCategory(id);
    res.status(200).json(res.__('categoryDeleted'));
  } catch (err) {
    next(err);
  }
});

module.exports = router;
