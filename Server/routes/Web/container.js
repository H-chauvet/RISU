const express = require("express");
const router = express.Router();

const containerCtrl = require("../../controllers/Common/container");
const jwtMiddleware = require("../../middleware/jwt");

router.get("/get", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const { id } = req.query;

    if (!id) {
      res.status(400);
      throw new Error("id is required");
    }
    const container = await containerCtrl.getContainerById(parseInt(id));
    res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.post("/delete", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const { id } = req.body;
    if (!id) {
      res.status(400);
      throw new Error("container is required");
    }
    await containerCtrl.deleteContainer(id);
    res.status(200).json("container deleted");
  } catch (err) {
    next(err);
  }
});

router.post("/create", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const { designs, containerMapping, height, width, saveName } = req.body;

    const container = await containerCtrl.createContainer({
      designs,
      containerMapping,
      height,
      width,
      saveName,
    });
    res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.put("/update", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
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
      throw new Error("id and name are required");
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
    next(err);
  }
});

router.put("/update-position", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const { id, latitude, longitude } = req.body;

    if (!id || !latitude || !longitude) {
      res.status(400);
      throw new Error("id and position are required");
    }

    const container = await containerCtrl.updateContainerPosition(id, {
      latitude,
      longitude,
    });
    res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.get("/listAll", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const container = await containerCtrl.getAllContainers();

    res.status(200).json({ container });
  } catch (err) {
    next(err);
  }
});

router.get(
  "/listByOrganization/:organizationId",
  async function (req, res, next) {
    try {
      jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
    } catch (err) {
      res.status(401);
      throw new Error("Unauthorized");
    }
    try {
      const organizationId = req.params.organizationId;
      const container =
        await containerCtrl.getContainerByOrganizationId(organizationId);

      res.status(200).json({ container });
    } catch (err) {
      next(err);
    }
  }
);

router.get("/listByContainer/:id", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const id = req.params.id;

    const container = await containerCtrl.getContainerById(id);
    res.status(200).json({ container });
  } catch (err) {
    next(err);
  }
});

router.post("/update-city/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  const id = parseInt(req.params.id);
  try {
    const { city } = req.body;

    if (!city) {
      res.status(400).json({
        error: "Email and at least one of city or city are required",
      });
      return;
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404).json({ error: "Container not found" });
      return;
    }

    const updateContainer = await containerCtrl.updateCity({
      id,
      city,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    next(err);
  }
});

router.post("/update-address/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  const id = parseInt(req.params.id);
  try {
    const { address } = req.body;

    if (!address) {
      res.status(400).json({
        error: "Email and at least one of address or address are required",
      });
      return;
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404).json({ error: "Container not found" });
      return;
    }

    const updateContainer = await containerCtrl.updateAddress({
      id,
      address,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    next(err);
  }
});

router.post("/update-name/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  const id = parseInt(req.params.id);
  try {
    const { saveName } = req.body;

    if (!saveName) {
      res.status(400).json({
        error: "Email and at least one of saveName or saveName are required",
      });
      return;
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404).json({ error: "Container not found" });
      return;
    }

    const updateContainer = await containerCtrl.updateSaveName({
      id,
      saveName,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    next(err);
  }
});

router.post("/update-information/:id", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  const id = parseInt(req.params.id);
  try {
    const { informations } = req.body;

    if (!informations) {
      res.status(400).json({
        error:
          "Email and at least one of informations or informations are required",
      });
      return;
    }

    const existingContainer = await containerCtrl.getContainerById(id);
    if (!existingContainer) {
      res.status(404).json({ error: "Container not found" });
      return;
    }

    const updateContainer = await containerCtrl.updateInformation({
      id,
      informations,
    });
    res.status(200).json(updateContainer);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
