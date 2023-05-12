const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const LandSchema = new Schema(
  {
    city: {
      type: String,
      required: true,
      index: true,
      trim: true,
    },
    area: {
      type: String,
      required: true,
      trim: true,
    },
    // polygon: [
    //   {
    //     latitude: {
    //       type: String,
    //       required: true,
    //       index: true,
    //       trim: true,
    //     },
    //     longitude: {
    //       type: String,
    //       required: true,
    //       index: true,
    //       trim: true,
    //     },
    //   },
    // ],
    parcelId: {
      type: String,
      required: true,
      trim: true,
      index: true,
      unique: true,
    },
    wardNo: {
      type: String,
      required: true,
      trim: true,
    },
    district: {
      type: String,
      required: true,
      index: true,
      trim: true,
    },
    address: {
      type: String,
      required: true,
      index: true,
      trim: true,
    },
    surveyNo: {
      type: String,
      required: true,
      trim: true,
    },
    province: {
      type: String,
      required: true,
      index: true,
      trim: true,
    },
    landPrice: {
      type: String,
      // required: true,
      trim: true,
    },
    isVerified: {
      type: String,
      required: true,
      default: "pending",
      index: true,
      enum: ["approved", "pending", "rejected"],
    },
    ownerUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    ownerHistory: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        default: [],
      },
    ],
    saleData: {
      type: String,
      default: "null",
      enum: ["null", "selling", "processing", "selled", "rejected"],
      index: true,
      required: true,
    },
    // landSaleId: {
    //   type: mongoose.Schema.Types.ObjectId,
    //   required: true,
    //   index: true,
    //   ref: "LandSale",
    // },
    geoJSON: { type: mongoose.Schema.Types.ObjectId, ref: "GeoJSON" },
  },
  { timestamps: true }
);

// LandSchema.plugin(mongoose_fuzzy_searching, { fields: ["parcelId"] });

const Land = mongoose.model("Land", LandSchema);
module.exports = Land;
