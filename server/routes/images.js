const express = require("express");
const router = express.Router();
const multer = require("multer");
const AWS = require("aws-sdk");
const { v4: uuidv4 } = require("uuid");

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// const db = require("../models");
// const auth = require("../authenticate");

const s3bucket = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_REGION,
});

router.route("/upload").post(upload.single("image"), async (req, res, next) => {
  const file = req.file;
  const filePath = `images/${uuidv4()}/${file.originalname}`;

  var params = {
    Bucket: process.env.AWS_BUCKET_NAME,
    Key: filePath,
    Body: file.buffer,
    ContentType: file.mimetype,
    ACL: "public-read",
  };

  s3bucket.upload(params, function (err, data) {
    if (err) {
      res.status(500).json({ error: true, Message: err });
    } else {
      const imageUrl = data.Location;
      res.send(imageUrl);
    }
  });
});

module.exports = router;
