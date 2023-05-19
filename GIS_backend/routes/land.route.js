const {
  createLand,
  getAllLands,
  patchLandByAdmin,
  deleteLand,
  landApprovedByAdmin,
  landRejectedByAdmin,
  getAllLandsByAdmin,
  getAllOwnedLands,
  getIndividualLandById,
  getGeoJSONDataById,
  patchLandCertificateDocument,
} = require("../controllers/land.controller");
const { checkIsAdmin } = require("../middlewares/check.is.admin");
const {
  checkIsUserVerified,
} = require("../middlewares/check.is.user.verified");
const { checkAuthValidation } = require("../middlewares/checkAuthentication");
const { uploadImages } = require("../middlewares/multer");
const { validate } = require("../middlewares/validate");
const { validator } = require("../utils/validator");

const router = require("express").Router({ mergeParams: true });

router.get("/", checkAuthValidation, getAllLands);

router.get("/user-lands", checkAuthValidation, getAllOwnedLands);

router.get("/individual/:id", checkAuthValidation, getIndividualLandById);

router.get("/geoJSON/:id", checkAuthValidation, getGeoJSONDataById);

router.post(
  "/:id/add-land",
  // validate(["id", "city", "province", "district", "wardNo", "address"]),
  // validator,
  checkAuthValidation,
  checkIsUserVerified,
  uploadImages({
    folderName: "GISLandRegistration/landDocument",
  }),
  createLand
);

// router.patch(
//   "/:id/land-certificate-image",
//   validate(["id"]),
//   validator,
//   checkAuthValidation,
//   uploadImages({
//     folderName: "GISLandRegistration/landDocument",
//   }),
//   patchLandCertificateDocument
// );

//for admin only ----------------------------------------------------------------
router.get("/admin", checkAuthValidation, checkIsAdmin, getAllLandsByAdmin);

router.patch(
  "/admin/:id/edit-land",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  patchLandByAdmin
);

router.patch(
  "/admin/:id/approve-land",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  landApprovedByAdmin
);

router.patch(
  "/admin/:id/reject-land",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  landRejectedByAdmin
);
//------------------------------------------------------------------

router.delete("/:id", checkAuthValidation, deleteLand);

module.exports = router;
