const mongoose = require("mongoose");
const GeoJSON = require("../models/geoJSON.model");

const fs = require("fs");

module.exports.connectDB = async (app) => {
  try {
    const port = process.env.PORT || 3000;
    app.set("port", port);

    const db = await mongoose.connect(process.env.MONGO_DB_URL, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    if (db) {
      console.log(
        "Connected to database with host:" +
          `${db?.connection?.host} and name: ${db?.connection?.name}`
      );
      app.listen(port, () => {
        console.log(
          `Server is listening on http://localhost: ${Date()}`,
          `, PORT ::`,
          port
        );
      });

      // const geoJSONData = JSON.parse(fs.readFileSync("./Parcel_geojson.json"));
      // // console.log(geoJSONData);
      // const geoJSONInstance = await GeoJSON.insertMany(geoJSONData.features);
      // // await geoJSONInstance((err, doc) => {
      // //   if (err) throw err;
      // //   console.log("Saved GeoJSON data to database");
      // //   // mongoose.disconnect();
      // // });
      // console.log(geoJSONInstance);
    }
  } catch (err) {
    console.log(err);
  }
};
