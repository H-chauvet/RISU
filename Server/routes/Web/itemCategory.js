const express = require("express");
const router = express.Router();

const itemCategoryCtrl = require("../../controllers/Common/itemCategory");
const jwtMiddleware = require("../../middleware/jwt");
const userCtrl = require("../../controllers/Web/user");
const languageMiddleware = require("../../middleware/language");

router.get("/", async function (req, res, next) {
  try {
    const itemCategories = await itemCategoryCtrl.getItemCategories();
    res.status(200).json(itemCategories);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/listAll", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const itemCategories = await itemCategoryCtrl.getItemCategories();
    res.status(200).json({ itemCategories });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    if (!req.params.id) {
      res.status(400);
      throw res.__("missingCategoryId");
    }
    const itemCategory = await itemCategoryCtrl.getItemCategoryFromId(
      req.params.id
    );
    res.status(200).json(itemCategory);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const name = req.body.name;
    if (!name) {
      res.status(400);
      throw res.__("missingName");
    }

    const itemCategory = await itemCategoryCtrl.createItemCategory(name);
    res.status(200).json(name);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.put("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { id, name } = req.body;
    if (!id || !name) {
      res.status(400);
      throw res.__("missingIdName");
    }

    const itemCategory = await itemCategoryCtrl.updateItemCategory(id, name);
    res.status(200).json(itemCategory);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.delete("/", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { id } = req.body;
    if (!id) {
      res.status(400);
      throw res.__("missingId");
    }

    await itemCategoryCtrl.deleteItemCategory(id);
    res.status(200).json(res.__("categoryDeleted"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
