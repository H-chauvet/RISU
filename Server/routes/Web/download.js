const express = require("express");
const router = express.Router();
const path = require('path');

router.get("/download", async function (req, res, next) {
  try {
    const filePath = path.join('/apk', 'client.apk');
    res.download(filePath, 'client.apk', (err) => {
        if (err) {
            console.error('Error during file download:', err);
            res.status(500).send(res.__('failedDownload'));
        } else {
            res.status(200);
        }
    });
  } catch (err) {
    console.error('Error:', err);
    res.status(500).send(res.__('errorOccured'));
  }
});

module.exports = router;
