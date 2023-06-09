const multer = require("multer");
const cloudinaryInit = require("../utils/cloudinary.init");
const path = require("path");
const { rename } = require("fs");

exports.uploadImages = ({
  folderName = "GISLandRegistration",
  // fileSize = 500000,
  allowedFileTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"],
}) => {
  const uploadImagesMulter = () => {
    // const storage = multer.memoryStorage();

    var storage = multer.diskStorage({
      destination: (req, file, cb) => {
        cb(null, "uploads");
      },
      filename: (req, file, cb) => {
        cb(
          null,
          // `GIS-${new Date()
          //   .toISOString()
          //   .replace(/:/g, "-")
          //   .replace(".", "-", " ")}-${
          //   file.originalname.toLowerCase().replace(/ /g, "-").split(".")[0]
          // }`
          `GIS-${Date.now()}${path.extname(file.originalname)}`
        );
      },
    });

    const fileFilter = (req, file, cb) => {
      console.log(allowedFileTypes.includes(file.mimetype));
      if (allowedFileTypes.includes(file.mimetype)) {
        cb(null, true);
      } else {
        cb("Images only");
        // cb(null, false);
      }
    };

    const upload = multer({
      storage,
      fileFilter: fileFilter,
      // limit: {
      //   fileSize,
      // },
    }).fields([
      {
        name: "frontCitizenshipImage",
      },
      {
        name: "backCitizenshipImage",
      },
      {
        name: "userImage",
      },
      {
        name: "voucherFormImage",
      },
      {
        name: "landCertificateImage",
      },
    ]);
    return upload;
  };

  const cloudinaryUpload = async (req, res, next) => {
    try {
      console.log({ file: req.file, files: req.files?.voucherFormImage });
      if (req.file) {
        const renameImage =
          new Date().toISOString().replace(/:/g, "-").replace(".", "-", " ") +
          "-" +
          file.originalname.toLowerCase().replace(/ /g, "-").split(".")[0];
        const result = await cloudinaryInit.uploader.upload(req.file.path, {
          folder: `developing/${folderName}`,
          resource_type: "image",
          public_id: renameImage,
        });
        console.log(result.public_id, result.secure_url);
      }

      if (req.files) {
        let userImage =
          req.files?.userImage?.length > 0 ? req.files?.userImage : null;
        let frontCitizenshipImage =
          req.files?.frontCitizenshipImage?.length > 0
            ? req.files?.frontCitizenshipImage
            : null;
        let backCitizenshipImage =
          req.files?.backCitizenshipImage?.length > 0
            ? req.files?.backCitizenshipImage
            : null;
        let voucherFormImage =
          req.files?.voucherFormImage?.length > 0
            ? req.files?.voucherFormImage
            : null;
        let landCertificateImage =
          req.files?.landCertificateImage?.length > 0
            ? req.files?.landCertificateImage
            : null;

        if (userImage) {
          await UploadingImage({ req, res, uploadimage: userImage });
        }
        if (frontCitizenshipImage) {
          await UploadingImage({
            req,
            res,
            uploadimage: frontCitizenshipImage,
          });
        }
        if (backCitizenshipImage) {
          await UploadingImage({
            req,
            res,
            uploadimage: backCitizenshipImage,
          });
        }
        if (voucherFormImage) {
          await UploadingImage({
            req,
            res,
            uploadimage: voucherFormImage,
          });
        }
        if (landCertificateImage) {
          await UploadingImage({
            req,
            res,
            uploadimage: landCertificateImage,
          });
        }
      }
      next();
    } catch (err) {
      return res.fail(err);
    }
  };

  const UploadingImage = async ({ req, res, uploadimage }) => {
    try {
      await Promise.all(
        uploadimage?.map(async (file) => {
          const renameImage =
            new Date().toISOString().replace(/:/g, "-").replace(".", "-", " ") +
            "-" +
            file.originalname.toLowerCase().replace(/ /g, "-").split(".")[0];
          console.log(renameImage);
          const [image] = await Promise.all([
            cloudinaryInit.uploader.upload(file.path, {
              folder: `developing/${folderName}`,
              resource_type: "image",
              public_id: renameImage,
            }),
          ]);
          console.log(image);
          file.location = image.secure_url;
          file.publicId = image.public_id;
        })
      );
    } catch (error) {
      console.log(error);
    }
  };

  return [uploadImagesMulter(), cloudinaryUpload];
};
