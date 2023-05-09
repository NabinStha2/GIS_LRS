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
} = require("../controllers/transfer.ownership.controller");
const { uploadImages } = require("../middlewares/multer");

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
  "/:id/approve-land-transfer",
  validate(["id"]),
  validator,
  checkAuthValidation,
  approveLandForTransferOwnership
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

module.exports = router;
