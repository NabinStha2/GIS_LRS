const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const TransferOwnershipSchema = new Schema(
  {
    landSaleId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "LandSale",
      required: true,
    },
    ownerUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    approvedUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    transerData: {
      type: String,
      default: "pending",
      enum: ["pending", "ongoing", "initiated", "completed", "rejected"],
      index: true,
      required: true,
    },
    transactionAmt: {
      type: Number,
      default: 0,
      required: true,
    },
    transactionDate: {
      type: Date,
      default: Date.now,
    },
    billToken: {
      type: String,
    },
    sellerBankAcc: {
      type: String,
    },
    buyerBankAcc: {
      type: String,
    },
    voucherFormFile: {
      voucherFormImage: {
        type: String,
        trim: true,
      },
      voucherFormPublicId: {
        type: String,
        trim: true,
      },
    },
  },
  { timestamps: true }
);

const TransferOwnership = mongoose.model(
  "TransferOwnership",
  TransferOwnershipSchema
);
module.exports = TransferOwnership;
