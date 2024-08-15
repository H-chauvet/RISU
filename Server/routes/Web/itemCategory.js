const express = require("express");
const router = express.Router();

const itemCategoryCtrl = require("../../controllers/Common/itemCategory");
const jwtMiddleware = require("../../middleware/jwt");

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

router.get("/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    if (!req.params.id) {
      res.status(400);
      throw "Id of the item category is required";
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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const name = req.body.name;
    if (!name) {
      res.status(400);
      throw "Name is required";
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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const { id, name } = req.body;
    if (!id || !name) {
      res.status(400);
      throw "id and name are required";
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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const { id } = req.body;
    if (!id) {
      res.status(400);
      throw "id is required";
    }

    await itemCategoryCtrl.deleteItemCategory(id);
    res.status(200).json("item category deleted");
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
