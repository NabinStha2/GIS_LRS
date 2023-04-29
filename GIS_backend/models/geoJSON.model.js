const mongoose = require("mongoose");

const geoJSONSchema = new mongoose.Schema(
  {
    type: { type: String, required: true },
    geometry: {
      type: mongoose.Schema.Types.Mixed,
      required: true,
      index: true,
    },
    properties: mongoose.Schema.Types.Mixed,
  },
  { timestamps: true }
);

const GeoJSON = mongoose.model("GeoJSON", geoJSONSchema);
module.exports = GeoJSON;
