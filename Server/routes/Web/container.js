const express = require("express");
const router = express.Router();

const containerCtrl = require("../../controllers/Common/container");
const jwtMiddleware = require("../../middleware/jwt");
const userCtrl = require("../../controllers/Web/user");
const languageMiddleware = require("../../middleware/language");

router.get("/get", async function (req, res, next) {
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

    const { id } = req.query;

    if (!id) {
      res.status(400);
      throw res.__("missingContainerId");
    }
    const container = await containerCtrl.getContainerById(res, parseInt(id));
    res.status(200).json(container);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

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
      throw res.__("missingContainerId");
    }
    await containerCtrl.deleteContainer(res, id);
    res.status(200).send(res.__("containerDeleted"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/create", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const { designs, containerMapping, height, width, saveName } = req.body;

    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);

    if (!user) {
      res.status(401);
      throw res.__("userNotFound");
    }
    languageMiddleware.setServerLanguage(req, user);

    const container = await containerCtrl.createContainer(
      res,
      {
        designs,
        containerMapping,
        height,
        width,
        saveName,
      },
      user.organizationId
    );
    res.status(200).json(container);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
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
    const {
      id,
      price,
      containerMapping,
      height,
      width,
      informations,
      designs,
      saveName,
    } = req.body;

    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    if (!id) {
      res.status(400);
      throw res.__("missingIdName");
    }

    const container = await containerCtrl.updateContainer(res, id, {
      price,
      containerMapping,
      height,
      width,
      informations,
      designs,
      saveName,
    });
    res.status(200).json(container);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.put("/update-position", async function (req, res, next) {
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

    const { id, latitude, longitude } = req.body;

    if (!id || !latitude || !longitude) {
      res.status(400);
      throw res.__("missingIdPos");
    }

    const position = await containerCtrl.getLocalisation({
      latitude,
      longitude,
    });

    if (position == "No address found") {
      res.status(400);
      throw res.__("missingAddress");
    }

    const container = await containerCtrl.updateContainerPosition(res, id, {
      latitude,
      longitude,
      city: position.city,
      address: position.address,
    });

    res.status(200).json(container);
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
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);
    const container = await containerCtrl.getAllContainers(res);
    res.status(200).json({ container });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get(
  "/listByOrganization/:organizationId",
  async function (req, res, next) {
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

      const organizationId = req.params.organizationId;
      const container = await containerCtrl.getContainerByOrganizationId(
        res,
        organizationId
      );

      res.status(200).json({ container });
    } catch (err) {
      if (res.statusCode == 200) {
        res.status(500);
      }
      res.send(err);
    }
  }
);

router.get("/listByContainer/:id", async function (req, res, next) {
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

    const id = req.params.id;

    const container = await containerCtrl.getContainerById(res, id);
    res.status(200).json({ container });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-city/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  const id = parseInt(req.params.id);
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { city } = req.body;

    if (!city) {
      res.status(400);
      throw res.__("missingMailCity");
    }

    const existingContainer = await containerCtrl.getContainerById(res, id);
    if (!existingContainer) {
      res.status(404);
      throw res.__("containerNotFound");
    }

    const updateContainer = await containerCtrl.updateCity(res, {
      id,
      city,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-address/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  const id = parseInt(req.params.id);
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { address } = req.body;

    if (!address) {
      res.status(400);
      throw res.__("missingMailAddress");
    }

    const existingContainer = await containerCtrl.getContainerById(res, id);
    if (!existingContainer) {
      res.status(404);
      throw res.__("containerNotFound");
    }

    const updateContainer = await containerCtrl.updateAddress(res, {
      id,
      address,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-name/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  const id = parseInt(req.params.id);
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { saveName } = req.body;

    if (!saveName) {
      res.status(400);
      throw res.__("missingMailName");
    }

    const existingContainer = await containerCtrl.getContainerById(res, id);
    if (!existingContainer) {
      res.status(404);
      throw res.__("containerNotFound");
    }

    const updateContainer = await containerCtrl.updateSaveName(res, {
      id,
      saveName,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/update-information/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  const id = parseInt(req.params.id);
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const { informations } = req.body;

    if (!informations) {
      res.status(400);
      throw res.__("missingNameInfo");
    }

    const existingContainer = await containerCtrl.getContainerById(res, id);
    if (!existingContainer) {
      res.status(404);
      throw res.__("containerNotFound");
    }

    const updateContainer = await containerCtrl.updateInformation(res, {
      id,
      informations,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
