const express = require("express");
const router = express.Router();

const itemCtrl = require("../../controllers/Common/items");
const jwtMiddleware = require("../../middleware/jwt");
const languageMiddleware = require('../../middleware/language')

router.post(
  "/delete",
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
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
      await itemCtrl.deleteItem(id);
      res.status(200).json(res.__('itemsDeleted'));
    } catch (err) {
      next(err);
    }
  }
);

router.post("/create", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

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
    next(err);
    return res.status(400).json(res.__('errorOccured'));
  }
});

router.put(
  "/update",
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

      const { id, name, available, containerId, price, image, description } =
        req.body;

      if (!id) {
        res.status(400);
        throw new Error(res.__('missingIdName'));
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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
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
          error: res.__('missingMailName'),
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);

      if (!existingUser) {
        res.status(404).json({ error: res.__('userNotFound') });
        return;
      }
      languageMiddleware.setServerLanguage(req, existingUser)
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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    const id = parseInt(req.params.id);
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

      const { name } = req.body;

      if (!name) {
        res.status(400).json({
          error: res.__('missingMailName'),
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: res.__('userNotFound') });
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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    const id = parseInt(req.params.id);
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

      const { price } = req.body;
      const priceTmp = parseFloat(price);
      if (!price) {
        res.status(400).json({
          error: res.__('missingMailPrice'),
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: res.__('userNotFound') });
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
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error(res.__('unauthorized'));
    }
    const id = parseInt(req.params.id);
    try {
      const user = userCtrl.getUserFromToken(req)
      languageMiddleware.setServerLanguage(req, user)

      const { description } = req.body;

      if (!description) {
        res.status(400).json({
          error: res.__('missingMailDescription')
        });
        return;
      }

      const existingUser = await itemCtrl.getItemFromId(id);
      if (!existingUser) {
        res.status(404).json({ error: res.__('userNotFound') });
        return;
      }
      languageMiddleware.setServerLanguage(req, existingUser)
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
