const { checkAuthValidation } = require("../middlewares/checkAuthentication");
const { validate } = require("../middlewares/validate");
const { validator } = require("../utils/validator");
const {
  addLandForTransferOwnership,
  approveLandForTransferOwnership,
  getAllLandForTransferOwnership,
  getLandForTransferOwnershipById,
  patchPaymentVoucherLandTransferOwnership,
  addPaymentFormForLandTransferOwnership,
  initiateTransferForLandTransferOwnership,
  getAllLandTransferOwnershipByAdmin,
  cancelLandTransferOwnershipByAdmin,
  rejectLandForTransferOwnership,
} = require("../controllers/transfer.ownership.controller");
const { uploadImages } = require("../middlewares/multer");
const { checkIsAdmin } = require("../middlewares/check.is.admin");

const router = require("express").Router();

router.get("/:id", checkAuthValidation, getAllLandForTransferOwnership);

router.get(
  "/individual/:id",
  checkAuthValidation,
  getLandForTransferOwnershipById
);

router.post(
  "/:id",
  validate(["id"]),
  validator,
  checkAuthValidation,
  addLandForTransferOwnership
);

router.patch(
  "/:id/payment-voucher-form",
  validate(["id"]),
  validator,
  checkAuthValidation,
  uploadImages({
    folderName: "GISLandRegistration/paymentForm",
  }),
  patchPaymentVoucherLandTransferOwnership
);

router.patch(
  "/:id",
  validate(["id"]),
  validator,
  checkAuthValidation,
  addPaymentFormForLandTransferOwnership
);

router.patch(
  "/:id/initiate",
  validate(["id"]),
  validator,
  checkAuthValidation,
  initiateTransferForLandTransferOwnership
);

// Admin ----------------------------------------------------------------
router.get(
  "/admin/data",
  checkAuthValidation,
  checkIsAdmin,
  getAllLandTransferOwnershipByAdmin
);

router.patch(
  "/:id/cancel",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  cancelLandTransferOwnershipByAdmin
);

router.patch(
  "/:id/approve-land-transfer",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  approveLandForTransferOwnership
);

router.patch(
  "/:id/reject-land-transfer",
  validate(["id"]),
  validator,
  checkAuthValidation,
  checkIsAdmin,
  rejectLandForTransferOwnership
);

module.exports = router;
