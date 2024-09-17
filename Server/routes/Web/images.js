const express = require('express');
const router = express.Router();

const imagesCtrl = require('../../controllers/Common/images');

// GET /api/images/:id
router.get('/:id', async (req, res) => {
    try {
        const files = await imagesCtrl.getItemImagesUrl(res, req.params.id);
        return res.status(200).send(files);
    } catch (error) {
        console.error('Error listing files: ', error);
        return res.status(500).send(res.__('errorOccurred'));
    }
});

module.exports = router;
