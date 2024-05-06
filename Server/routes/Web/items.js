const express = require("express");
const router = express.Router();

const itemCtrl = require("../../controllers/Common/items");
const jwtMiddleware = require("../../middleware/jwt");

router.post(
  "/delete",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      const { id } = req.body;
      if (!id) {
        res.status(400);
        throw new Error("userId is required");
      }
      await itemCtrl.deleteItem(id);
      res.status(200).json("items deleted");
    } catch (err) {
      next(err);
    }
  }
);

router.post("/create", jwtMiddleware.checkToken, async (req, res) => {
  try {
    const { id, name, available, price, containerId, description, image } =
      req.body;
    const item = await itemCtrl.createItem({
      id,
      name,
      available,
      price,
      containerId,
      description,
      image,
    });
    res.status(200).json(item);
  } catch (err) {
    console.log(err);
    return res.status(400).json("An error occured.");
  }
});

router.put(
  "/update",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      const { id, name, available, containerId, price, image, description } =
        req.body;

      if (!id) {
        res.status(400);
        throw new Error("id and name are required");
      }

      const item = await containerCtrl.updateItem(id, {
        name,
        available,
        containerId,
        price,
        image,
        description,
      });

      res.status(200).json(item);
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  "/update/:itemId",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    const id = parseInt(req.params.itemId);
    try {
      const { name, description, price, available } = req.body;
      const isPrice = parseInt(price);
      let isAvailable = false;
      if (available == "true") {
        isAvailable = true;
      } else {
        isAvailable = false;
      }
      if (!name) {
        res.status(400).json({
          error: "Email and at least one of name or name are required",
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await itemCtrl.updateItemCtn({
        id,
        name,
        description,
        isPrice,
        isAvailable,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

router.get(
  "/listAllByContainerId",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      const containerId = req.query.containerId;
      const item = await itemCtrl.getItemByContainerId(parseInt(containerId));

      res.status(200).json({ item });
    } catch (err) {
      next(err);
    }
  }
);

router.get(
  "/listAllByCategory",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      const category = req.query.category;
      const item = await itemCtrl.getItemByCategory(category);

      res.status(200).json({ item });
    } catch (err) {
      next(err);
    }
  }
);

router.get(
  "/listAll",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    try {
      const item = await itemCtrl.getAllItem();

      res.status(200).json({ item });
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  "/update-name/:id",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    const id = parseInt(req.params.id);
    try {
      const { name } = req.body;

      if (!name) {
        res.status(400).json({
          error: "Email and at least one of name or name are required",
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await itemCtrl.updateName({
        id,
        name,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  "/update-price/:id",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    const id = parseInt(req.params.id);
    try {
      const { price } = req.body;
      const priceTmp = parseFloat(price);
      if (!price) {
        res.status(400).json({
          error: "Email and at least one of price or price are required",
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await itemCtrl.updatePrice({
        id,
        priceTmp,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  "/update-description/:id",
  jwtMiddleware.checkToken,
  async function (req, res, next) {
    const id = parseInt(req.params.id);
    try {
      const { description } = req.body;

      if (!description) {
        res.status(400).json({
          error:
            "Email and at least one of description or description are required",
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: "User not found" });
        return;
      }

      const updatedUser = await itemCtrl.updateDescription({
        id,
        description,
      });
      res.status(200).json(updatedUser);
    } catch (err) {
      next(err);
    }
  }
);

module.exports = router;
