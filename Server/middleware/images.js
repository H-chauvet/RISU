const multer = require("multer");
const { S3Client } = require("@aws-sdk/client-s3");
require("dotenv").config({ path: "../.env" });

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

const awsBucketName = process.env.AWS_BUCKET_NAME;
const awsBucketRegion = process.env.AWS_BUCKET_REGION;
const awsAccessKey = process.env.AWS_ACCESS_KEY;
const awsSecretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;

const s3Client = new S3Client({
  region: awsBucketRegion,
  credentials: {
    accessKeyId: awsAccessKey,
    secretAccessKey: awsSecretAccessKey,
  },
});

const itemImagesFolder = "items/";
const profileImagesFolder = "profiles/";
const containerImagesFolder = "containers/";

module.exports = {
  awsBucketName,
  awsBucketRegion,
  awsAccessKey,
  awsSecretAccessKey,
  itemImagesFolder,
  profileImagesFolder,
  containerImagesFolder,
  upload,
  storage,
  s3Client,
};
