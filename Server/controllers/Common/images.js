const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
const { GetObjectCommand, ListObjectsV2Command } = require("@aws-sdk/client-s3");

const imagesMiddleware = require('../../middleware/images');
const itemsCtrl = require('../../controllers/Common/items');

const listFilesInS3Folder = async (folderPath) => {
    try {
        const params = {
            Bucket: imagesMiddleware.awsBucketName,
            Prefix: folderPath
        };
        const command = new ListObjectsV2Command(params);
        const data = await imagesMiddleware.s3Client.send(command);
        var files = [];

        if (data.Contents) {
            data.Contents.forEach(file => {
                if (!file.Key.endsWith('/')) {
                    files.push({name: file.Key});
                }
            });
        }
        return files;
    } catch (error) {
        throw error;
    }
}

exports.getItemImagesUrl = async (res, itemId, index = -1) => {
    try {
        const item = await itemsCtrl.getItemFromId(res, itemId);
        if (!item) {
            throw new Error('Item not found');
        }
        const files = await listFilesInS3Folder(`${imagesMiddleware.itemImagesFolder}${item.name}-${item.id}${index != -1 ? `/${index}` : ''}`);
        if (!files) {
            return [];
        }
        var imagesUrl = [];

        for (const file of files) {
            imagesUrl.push(await getSignedUrl(
                imagesMiddleware.s3Client,
                new GetObjectCommand({
                    Bucket: imagesMiddleware.awsBucketName,
                    Key: file.name
                }),
                { expiresIn: 3600 } // 1 hour
            ));
        }
        return imagesUrl;
    } catch (error) {
        throw error;
    }
}
