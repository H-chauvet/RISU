const express = require("express");
const router = express.Router();

const itemCtrl = require("../../controllers/Common/items");
const jwtMiddleware = require("../../middleware/jwt");
const languageMiddleware = require("../../middleware/language");
const imagesMiddleware = require("../../middleware/images");
const userCtrl = require("../../controllers/Web/user");

router.post("/delete", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
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
      throw "Id is required";
    }
    await itemCtrl.deleteItem(res, id);
    res.status(200).send(res.__("itemsDeleted"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/create",
  imagesMiddleware.upload.array('images', 5),
  async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);
    console.log(decodedToken);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    console.log(user)
    languageMiddleware.setServerLanguage(req, user);

    const { name, available, price, containerId, description } =
      req.body;
      console.log(req.body);
    const item = await itemCtrl.createItem(res, {
      name,
      available,
      price,
      containerId,
      description,
    });
    console.log(req.files);
    console.log(item);
    var count = 0;
    for (const file of req.files) {
      const params = {
          Bucket: imagesMiddleware.awsBucketName,
          Key: `${imagesMiddleware.itemImagesFolder}${item.name}-${item.id}/${count}`,
          Body: file.buffer,
          ContentType: file.mimetype
      };
      const command = new imagesMiddleware.PutObjectCommand(params);
      count++;
      await imagesMiddleware.s3Client.send(command);
    }
    return res.status(200).json(item);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    console.error(err);
    return res.send(err);
  }
});

router.put("/update", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { id, name, available, containerId, price, description } =
      req.body;

    if (!id) {
      res.status(400);
      throw res.__("missingId");
    }

    const item = await itemCtrl.updateItem(res, id, {
      name,
      available,
      containerId,
      price,
      description,
    });

    res.status(200).json(item);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update/:itemId", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const id = parseInt(req.params.itemId);
    const { name, description, price, available } = req.body;
    const isPrice = parseInt(price);
    let isAvailable = false;
    if (available == "true") {
      isAvailable = true;
    } else {
      isAvailable = false;
    }
    if (!name) {
      res.status(400);
      throw res.__("missingMailName");
    }

    const existingUser = await itemCtrl.getItemFromId(res, id);
    if (!existingUser) {
      res.status(404);
      throw res.__("userNotFound");
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    const updatedUser = await itemCtrl.updateItemCtn(res, {
      id,
      name,
      description,
      isPrice,
      isAvailable,
    });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/listAllByContainerId", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const containerId = req.query.containerId;
    const item = await itemCtrl.getItemByContainerId(
      res,
      parseInt(containerId)
    );

    res.status(200).json({ item });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/listAllByCategory", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const category = req.query.category;
    const item = await itemCtrl.getItemByCategory(res, category);

    res.status(200).json({ item });
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
    const item = await itemCtrl.getAllItems(res);

    res.status(200).json({ item });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-name/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const id = parseInt(req.params.id);
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);
    const { name } = req.body;

    if (!name) {
      res.status(400);
      throw res.__("missingMailName");
    }

    const existingUser = await itemCtrl.getItemFromId(res, id);
    if (!existingUser) {
      res.status(404);
      throw res.__("userNotFound");
    }

    const updatedUser = await itemCtrl.updateName(res, {
      id,
      name,
    });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-price/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const id = parseInt(req.params.id);
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);
    const { price } = req.body;
    const priceTmp = parseFloat(price);
    if (!price) {
      res.status(400);
      throw res.__("missingMailPrice");
    }

    const existingUser = await itemCtrl.getItemFromId(res, id);
    if (!existingUser) {
      res.status(404);
      throw "User not found";
    }

    const updatedUser = await itemCtrl.updatePrice(res, {
      id,
      priceTmp,
    });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-description/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }

  try {
    const id = parseInt(req.params.id);
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);
    const { description } = req.body;

    if (!description) {
      res.status(400);
      throw res.__("missingMailDescription");
    }

    const existingUser = await itemCtrl.getItemFromId(res, id);
    if (!existingUser) {
      res.status(404);
      throw res.__("userNotFound");
    }

    const updatedUser = await itemCtrl.updateDescription(res, {
      id,
      description,
    });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
