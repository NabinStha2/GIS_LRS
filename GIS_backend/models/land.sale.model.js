const mongoose = require("mongoose");

const LandSaleSchema = new mongoose.Schema(
  {
    landId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      index: true,
      ref: "Land",
    },
    parcelId: {
      type: String,
      required: true,
      index: true,
    },
    ownerUserId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      index: true,
      ref: "User",
    },
    saleData: {
      type: String,
      default: "selling",
      enum: ["selling", "processing", "transferring", "selled", "rejected"],
      index: true,
      required: true,
    },
    prevOwnerUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    requestedUserId: [
      {
        user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
        landPrice: { type: String, required: true },
      },
    ],
    rejectedUserId: [
      // {
      //   type: mongoose.Schema.Types.ObjectId,
      //   ref: "User",
      //   default: [],
      // },
      {
        user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
        landPrice: { type: String, required: true },
      },
    ],
    // approvedUserId: {
    //   type: mongoose.Schema.Types.ObjectId,
    //   ref: "User",
    // },
    approvedUserId: {
      user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
      landPrice: { type: String },
    },
    landPrice: {
      type: String,
      required: true,
      trim: true,
    },
    geoJSON: { type: mongoose.Schema.Types.ObjectId, ref: "GeoJSON" },
  },
  { timestamps: true }
);

const LandSale = mongoose.model("LandSale", LandSaleSchema);
module.exports = LandSale;
