const express = require("express");
const router = express.Router();

const containerCtrl = require("../../controllers/Common/container");
const jwtMiddleware = require("../../middleware/jwt");
const userCtrl = require("../../controllers/Web/user");

router.get("/get", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const { id } = req.query;

    if (!id) {
      res.status(400);
      throw "id is required";
    }
    const container = await containerCtrl.getContainerById(parseInt(id));
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
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const { id } = req.body;
    if (!id) {
      res.status(400);
      throw "container id is required";
    }
    await containerCtrl.deleteContainer(id);
    res.status(200).json("container deleted");
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
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const { designs, containerMapping, height, width, saveName } = req.body;

    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(decodedToken.userMail);

    if (!user) {
      res.status(401);
      throw "Unable to find user";
    }

    const container = await containerCtrl.createContainer(
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
    res.status(401);
    throw "Unauthorized";
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

    if (!id) {
      res.status(400);
      throw "id is required";
    }

    const container = await containerCtrl.updateContainer(id, {
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
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const { id, latitude, longitude } = req.body;

    if (!id || !latitude || !longitude) {
      res.status(400);
      throw "id and position are required";
    }

    const position = await containerCtrl.getLocalisation({
      latitude,
      longitude,
    });

    if (position == "No address found") {
      res.status(400);
      throw "No address found";
    }

    const container = await containerCtrl.updateContainerPosition(id, {
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
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const container = await containerCtrl.getAllContainers();

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
      res.status(401);
      throw "Unauthorized";
    }
    try {
      const organizationId = req.params.organizationId;
      const container =
        await containerCtrl.getContainerByOrganizationId(organizationId);

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
    res.status(401);
    throw "Unauthorized";
  }
  try {
    const id = req.params.id;

    const container = await containerCtrl.getContainerById(id);
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
    res.status(401);
    throw "Unauthorized";
  }
  const id = parseInt(req.params.id);
  try {
    const { city } = req.body;

    if (!city) {
      res.status(400);
      throw "Id and at least one city are required";
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404);
      throw "Container not found";
    }

    const updateContainer = await containerCtrl.updateCity({
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
    res.status(401);
    throw "Unauthorized";
  }
  const id = parseInt(req.params.id);
  try {
    const { address } = req.body;

    if (!address) {
      res.status(400);
      throw "Id and at least one address are required";
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404);
      throw "Container not found";
    }

    const updateContainer = await containerCtrl.updateAddress({
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
    res.status(401);
    throw "Unauthorized";
  }
  const id = parseInt(req.params.id);
  try {
    const { saveName } = req.body;

    if (!saveName) {
      res.status(400);
      throw "Id and a save name are required";
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404);
      throw "Container not found";
    }

    const updateContainer = await containerCtrl.updateSaveName({
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
    res.status(401);
    throw "Unauthorized";
  }
  const id = parseInt(req.params.id);
  try {
    const { informations } = req.body;

    if (!informations) {
      res.status(400);
      throw "Id and at least one informations are required";
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404);
      throw "Container not found";
    }

    const updateContainer = await containerCtrl.updateInformation({
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
