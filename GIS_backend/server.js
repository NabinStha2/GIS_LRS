require("dotenv").config();
const express = require("express");
const app = express();
const cors = require("cors");
const morgan = require("morgan");
const { connectDB } = require("./config/db");
const MainRouter = require("./routes/main.route");
const { SuccessCase, failCase } = require("./utils/requestHandler");
const { emailInitialSetup } = require("./utils/mail");
const MongoClient = require("mongodb").MongoClient;

app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

emailInitialSetup();

connectDB(app);

app.use("*", (req, res, next) => {
  res.fail = failCase({ req, res });
  res.success = SuccessCase({ req, res });
  next();
});

app.use("/api", MainRouter);

// Connection URI for MongoDB
const uri = "mongodb://localhost:27017/myNewDatabase";

// Name of the collection to insert the data into
const collectionName = "myCollection";

// Read the JSON file
// const geoJSONData = JSON.parse(fs.readFileSync("./WRC_WGC_84.geojson"));

// Connect to MongoDB and insert the data
// MongoClient.connect(uri, (err, client) => {
//   if (err) throw err;

//   const db = client.db();

//   // console.log(data);

//   // db.collection(collectionName).findOne((err, res) => {
//   //   if (err) throw err;
//   //   console.log(res);
//   // });

//   // client.close();

//   db.collection(collectionName).insertMany(data.features, (err, result) => {
//     if (err) throw err;

//     console.log(`${result.insertedCount} documents inserted`);
//     client.close();
//   });
// });

// app.use("/", (req, res, next) => {
//   return res.success("", "Welcome to the GIS Land Registration System.");
// });

app.use("*", (req, res, next) => {
  return res.status(404).json({
    success: false,
    message: "Api endpoint does not exist!",
  });
});
