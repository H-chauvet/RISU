const express = require('express');
const router = express.Router();
const passport = require('passport');
const { PutObjectCommand, GetObjectCommand, ListObjectsV2Command } = require("@aws-sdk/client-s3");

const imagesMiddleware = require('../../middleware/images');
const imagesCtrl = require('../../controllers/Common/images');
const userCtrl = require('../../controllers/Web/user');

// POST /api/images
router.post('/',
    imagesMiddleware.upload.array('images', 5),
    passport.authenticate('jwt', { session: false}),
    async (req, res) => {
        try {
            if (!req.user) {
                return res.status(401).send('Invalid token')
            }
            const user = await userCtrl.findUserById(req.user.id)
            if (!user) {
                return res.status(401).send('User not found')
            }
            const item = req.item
            if (!item.id) {
                return res.status(400).send('Item id is required')
            }
            var count = 0;
            const uploadPromises = req.files.map(file => {
                const params = {
                    Bucket: imagesMiddleware.awsBucketName,
                    Key: `${imagesMiddleware.itemImagesFolder}${item.name}-${item.id}/${count}`,
                    Body: file.buffer,
                    ContentType: file.mimetype
                };
                const command = new PutObjectCommand(params);
                count++;
                return imagesMiddleware.s3Client.send(command);
            });
            await Promise.all(uploadPromises);

            return res.status(200).send('Image uploaded successfully');
        }
        catch (error) {
            console.log('Error sending image:', error);
        }
});

// GET /api/images/:id
router.get('/:id', async (req, res) => {
    try {
        const files = await imagesCtrl.getItemImagesUrl(req.params.id);
        return res.status(200).send(files);
    } catch (error) {
        console.error('Error listing files: ', error);
        return res.status(500).send('Error listing files');
    }
});

module.exports = router;