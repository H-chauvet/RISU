const express = require("express");
const router = express.Router();
const path = require('path');


router.get("/assetlinks.json", (req, res) => {
    const rootDir = process.cwd();
    res.sendFile(path.resolve(rootDir, ".well-known/assetlinks.json"));
});

module.exports = router;