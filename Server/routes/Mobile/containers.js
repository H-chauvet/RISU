const express = require("express");
const router = express.Router();

const containerCtrl = require("../../controllers/Common/container");
const itemCtrl = require("../../controllers/Common/items");
const imagesCtrl = require("../../controllers/Common/images");

router.get("/listAll", async function (req, res, next) {
  try {
    const container = await containerCtrl.listContainers(res);

    return res.status(200).json(container);
  } catch (err) {
    next(err);
  }
});

router.get("/:containerId", async (req, res, next) => {
  try {
    if (!req.params.containerId || req.params.containerId === "") {
      return res.status(400).send(res.__("missingContainerId"));
    }
    const container = await containerCtrl.getContainerById(
      res,
      parseInt(req.params.containerId)
    );
    if (!container) {
      return res.status(404).send(res.__("containerNotFound"));
    }
    const count = await itemCtrl.getAvailableItemsCount(
      res,
      parseInt(req.params.containerId)
    );

    return res.status(200).json({ ...container, count });
  } catch (err) {
    next(err);
  }
});

router.get("/:containerId/articleslist", async (req, res) => {
  try {
    const containerId = req.params.containerId;
    if (!containerId || containerId === "") {
      return res.status(400).send(res.__("missingContainerId"));
    }
    const articleName = req.query.articleName || "";
    const categoryId =
      req.query.categoryId === "null" ? null : req.query.categoryId;
    const isAvailable = req.query.isAvailable === "false" ? false : true;
    const isAscending = req.query.isAscending === "false" ? false : true;
    const sortBy = req.query.sortBy || "price";
    const min = parseFloat(req.query.min) || 0;
    const max = parseFloat(req.query.max) || 1000000;
    const items = await containerCtrl.getItemsWithFilters(
      res,
      parseInt(containerId),
      articleName,
      isAscending,
      isAvailable,
      categoryId,
      sortBy,
      min,
      max
    );
    for (const item of items) {
      imageUrl = await imagesCtrl.getItemImagesUrl(res, item.id, 0);
      item.imageUrl = imageUrl[0];
    }
    return res.status(200).json(items);
  } catch (err) {
    console.error(err);
    return res.status(400).send(res.__("errorRetrievingItems"));
  }
});

module.exports = router;
