const { default: mongoose } = require("mongoose");
const GeoJSON = require("../models/geoJSON.model");
const Land = require("../models/land.model");
const LandSale = require("../models/land.sale.model");
const User = require("../models/user.model");
const { getSearchPaginatedData } = require("../utils/pagination");
const { SetErrorResponse } = require("../utils/responseSetter");
const { deleteFileCloudinary } = require("../utils/fileHandling");

exports.createLand = async (req, res) => {
  try {
    const userId = res.locals.authData?._id;

    const {
      city,
      area,
      parcelId,
      address,
      surveyNo,
      // landPrice,
      wardNo,
      province,
      district,
      mapSheetNo,
      // polygon,
    } = req.body;

    const geoJSONData = await GeoJSON.findOne({
      "properties.id": parcelId,
    });
    console.log(parcelId);
    // console.log(geoJSONData);
    if (!geoJSONData) {
      // await deleteFileCloudinary(req.files?.landCertificateImage[0]?.publicId);
      throw new SetErrorResponse("No recorded parcel id found!", 404);
    }

    const land = await Land.findOne({
      parcelId: parcelId,
      isVerified: "approved",
    });
    if (land) {
      // await deleteFileCloudinary(req.files?.landCertificateImage[0]?.publicId);
      throw new SetErrorResponse(
        "Land already exists with this parcel Id!",
        500
      );
    }

    const landCertificateImageLocation =
      req.files?.landCertificateImage?.length > 0
        ? req.files.landCertificateImage[0]?.location
        : undefined;

    console.log(req.files?.landCertificateImage);

    // var editBackQuery = {};
    // if (landCertificateImageLocation) {
    //   editBackQuery = {
    //     landCertificateFile: {},
    //   };
    //   editBackQuery.landCertificateFile.landCertificateImage =
    //     landCertificateImageLocation;
    //   editBackQuery.landCertificateFile.landCertificatePublicId =
    //     req.files?.landCertificateImage[0]?.publicId;
    // }

    const newLand = new Land({
      city,
      area: geoJSONData.properties.Area,
      parcelId,
      // address,
      wardNo: geoJSONData.properties.wardno,
      province,
      district,
      mapSheetNo: geoJSONData.properties.mapsheetno,
      // polygon,
      // landPrice,
      ownerUserId: userId,
      street: geoJSONData.properties.Street,
      geoJSON: geoJSONData,
      landCertificateFile: {
        landCertificateImage: landCertificateImageLocation,
        landCertificatePublicId: req.files?.landCertificateImage[0]?.publicId,
      },
    });

    await newLand.save();

    console.log(newLand);

    const existingUser = await User.findById({ _id: userId }).lean();

    if (!existingUser) {
      // await deleteFileCloudinary(req.files?.landCertificateImage[0]?.publicId);
      throw new SetErrorResponse("User not found", 404);
    }

    const user = await User.findByIdAndUpdate(
      { _id: userId },
      { ownedLand: [...existingUser.ownedLand, newLand] },
      { new: true }
    ).lean();

    console.log(user);

    return res.success({ landData: newLand }, "land created successfully");
  } catch (err) {
    await deleteFileCloudinary(req.files?.landCertificateImage[0]?.publicId);
    console.log(`Err add lands : ${err.message}`);
    return res.fail(err);
  }
};

// exports.patchLandCertificateDocument = async (req, res) => {
//   try {
//     console.log(req.files);
//     const userId = res.locals.authData?._id;
//     const backCitizenshipImageLocation =
//       req.files?.backCitizenshipImage?.length > 0
//         ? req.files.backCitizenshipImage[0]?.location
//         : undefined;

//     var editBackQuery = {};

//     if (backCitizenshipImageLocation) {
//       editBackQuery = {
//         backCitizenshipFile: {},
//       };
//       editBackQuery.backCitizenshipFile.backCitizenshipImage =
//         backCitizenshipImageLocation;
//       editBackQuery.backCitizenshipFile.backCitizenshipPublicId =
//         req.files?.backCitizenshipImage[0]?.publicId;
//     }

//     User.findById({ _id: userId })
//       .lean()
//       .then(async (res) => {
//         console.log(res.backCitizenshipFile?.backCitizenshipPublicId);
//         if (
//           backCitizenshipImageLocation &&
//           res.backCitizenshipFile?.backCitizenshipPublicId
//         ) {
//           await deleteFileCloudinary(
//             res.backCitizenshipFile?.backCitizenshipPublicId
//           );
//         }
//       })
//       .catch((err) => {
//         throw new SetErrorResponse("Error deleting file cloudinary", 500);
//       });

//     const user = await User.findOneAndUpdate(
//       { _id: userId },
//       {
//         ...editBackQuery,
//       },
//       { new: true }
//     ).lean();

//     // if (
//     //   backCitizenshipImageLocation &&
//     //   user?.backCitizenshipFile?.backCitizenshipPublicId
//     // ) {
//     //   deleteFileLocal({ imagePath: req.files.backCitizenshipImage[0]?.path });
//     // }

//     if (!user || user.isVerified != "approved") {
//       throw new SetErrorResponse("User not found"); // default (Not found,404)
//     }

//     return res.success({ userData: user }, "Success");
//   } catch (err) {
//     res.fail(err);
//   }
// };

module.exports.getIndividualLandById = async (req, res) => {
  try {
    const land = await Land.findById({ _id: req.params.id })
      .populate({ path: "ownerUserId geoJSON" })
      .lean();

    if (!land) {
      throw new SetErrorResponse("Land not found", 404);
    }

    return res.success({ landData: land });
  } catch (err) {
    console.log(`Error from getIndividualLandById :: ${err.message}`);
    return res.fail(err);
  }
};

module.exports.getGeoJSONDataById = async (req, res) => {
  try {
    const geoJSONData = await GeoJSON.findById({ _id: req.params.id }).lean();

    if (!geoJSONData) {
      throw new SetErrorResponse("Land not found", 404);
    }

    return res.success({ geoJSONData: geoJSONData });
  } catch (err) {
    console.log(`Error from getGeoJSONDataById :: ${err.message}`);
    return res.fail(err);
  }
};

exports.getAllLands = async (req, res) => {
  try {
    const {
      page,
      limit,
      search,
      sort,
      city,
      district,
      province,
      latlng,
      radius,
    } = req?.query;
    let query = {};
    console.log(search);
    if (search) {
      query.parcelId = { $regex: search, $options: "i" };
    }
    if (city) {
      query.city = { $regex: city, $options: "i" };
    }
    if (district) {
      query.district = { $regex: district, $options: "i" };
    }
    if (province) {
      query.province = { $regex: province, $options: "i" };
    }
    query.isVerified = "approved";

    if (latlng) {
      GeoJSON.find({
        geometry: {
          $geoNear: {
            $geometry: {
              type: "Point",
              coordinates: [
                parseFloat(latlng.split(",")[0]),
                parseFloat(latlng.split(",")[1]),
              ],
              // coordinates: [83.9799461371451, 28.2561422405137],
            },
            $minDistance: 1,
            $maxDistance: parseInt(radius) ?? 1000,
          },
        },
      }).exec(async function (err, geoData) {
        if (err) throw new SetErrorResponse(err, 500);

        var d = geoData.map((e) => e._id);
        console.log(d.length);

        query.geoJSON = { $in: d };
        // console.log(query);

        const lands = await getSearchPaginatedData({
          model: Land,
          reqQuery: {
            sort,
            page,
            limit,
            query,
            populate: {
              path: "ownerUserId geoJSON",
              select: "-frontCitizenshipFile -backCitizenshipFile -ownedLand",
            },
            pagination: true,
            modFunction: (document) => {
              return document;
            },
          },
          search: search,
        });

        if (!lands) {
          throw new SetErrorResponse("Land not found", 404);
        }

        console.log({ data: lands });
        return res.success({ landData: lands });

        // Land.find({ isVerified: "approved", geoJSON: { $in: d } })
        //   .populate({
        //     path: "ownerUserId geoJSON",
        //     select: "-frontCitizenshipFile -backCitizenshipFile -ownedLand",
        //   })
        //   .exec(function (err, landData) {
        //     if (err) throw new SetErrorResponse(err, 404);

        //     console.log({ data: landData.length });
        //     return res.success({ landData: landData });
        //   });
      });
    } else {
      console.log(query);
      const lands = await getSearchPaginatedData({
        model: Land,
        reqQuery: {
          sort,
          page,
          limit,
          query,
          populate: {
            path: "ownerUserId geoJSON ownerHistory",
            // select: "-frontCitizenshipFile -backCitizenshipFile -ownedLand",
          },
          pagination: true,
          modFunction: (document) => {
            return document;
          },
        },
        search: search,
      });

      if (!lands) {
        throw new SetErrorResponse("Land not found", 404);
      }

      console.log({ data: lands });
      return res.success({ landData: lands });
    }
  } catch (err) {
    console.log(`Err get all lands : ${err}`);
    return res.fail(err);
  }
};

exports.getAllOwnedLands = async (req, res) => {
  try {
    const userId = res.locals.authData?._id;
    const {
      page,
      limit,
      search = "",
      sort,
      city,
      district,
      province,
    } = req?.query;
    let query = {};
    if (search) {
      query.parcelId = { $regex: search, $options: "i" };
    }
    // if (city) {
    //   query.city = { $regex: city, $options: "i" };
    // }
    // if (district) {
    //   query.district = { $regex: district, $options: "i" };
    // }
    // if (province) {
    //   query.province = { $regex: province, $options: "i" };
    // }
    // query.isVerified = "approved";
    console.log(`limit: ${limit} :: page: ${page}`);

    query.ownerUserId = userId;

    const lands = await getSearchPaginatedData({
      model: Land,
      reqQuery: {
        sort,
        page,
        limit,
        query,
        populate: {
          path: "ownerUserId geoJSON",
          select: "-frontCitizenshipFile -backCitizenshipFile -ownedLand",
        },
        pagination: true,
        modFunction: (document) => {
          return document;
        },
      },
      search: search,
    });

    if (!lands) {
      throw new SetErrorResponse("Land not found", 404);
    }
    return res.success({ landData: lands });
  } catch (err) {
    console.log(`Err get owned lands : ${err}`);
    return res.fail(err);
  }
};

exports.deleteLand = async (req, res) => {
  try {
    const landId = req.params.id;

    if (!res.locals.authData.isAdmin) {
      const existingLand = await Land.findById({ _id: landId }).lean();

      if (existingLand?.ownerUserId != res.locals.authData?._id) {
        throw new SetErrorResponse(
          "Not authorized for current user to delete land",
          401
        );
      }
    }

    const land = await Land.findByIdAndDelete({ _id: landId });
    if (!land) {
      throw new SetErrorResponse("Land not found"); // default (Not found,404)
    }

    const existingUser = await User.findById({
      _id: res.locals.authData?._id,
    }).lean();

    var filteredData;
    if (existingUser) {
      filteredData = existingUser.ownedLand.filter((e) => e != landId);
      // console.log(filteredData);
      const updatedUser = await User.findByIdAndUpdate(
        {
          _id: res.locals.authData?._id,
        },
        { ownedLand: filteredData },
        {
          new: true,
        }
      );
      console.log(updatedUser);
    }
    const landSale = await LandSale.findOneAndDelete({ landId: landId }).lean();

    return res.success({ landData: land }, "Land Deleted ");
  } catch (err) {
    console.log(`Err from delete lands : ${err}`);
    return res.fail(err);
  }
};

// only for admin ------------------------------------
exports.landApprovedByAdmin = async (req, res) => {
  try {
    const landId = req.params?.id;
    const land = await Land.findByIdAndUpdate(
      { _id: landId },
      {
        isVerified: "approved",
      },
      { new: true }
    ).lean();

    return res.success({ landData: land }, "Land approved successfully");
  } catch (err) {
    return res.fail(err);
  }
};

exports.landRejectedByAdmin = async (req, res) => {
  try {
    const landId = req.params?.id;

    const existingLand = await Land.findById({ _id: landId }).lean();
    if (!existingLand) {
      throw new SetErrorResponse("Land not found");
    }
    if (existingLand?.isVerified == "approved") {
      throw new SetErrorResponse(
        "Already approved!,so cannot reject the land",
        400
      );
    }
    const land = await Land.findByIdAndDelete({ _id: landId }).lean();

    const existingUser = await User.findById({
      _id: land.ownerUserId,
    }).lean();

    var filteredData;
    if (existingUser) {
      filteredData = existingUser.ownedLand.filter((e) => e != landId);
      // console.log(filteredData);
      const updatedUser = await User.findByIdAndUpdate(
        {
          _id: existingUser._id,
        },
        { ownedLand: filteredData },
        {
          new: true,
        }
      );
      console.log(updatedUser);
    }

    return res.success({ landData: land }, "Land rejected successfully");
  } catch (err) {
    console.log(`Err landRejectedByAdmin : ${err}`);
    return res.fail(err);
  }
};

exports.patchLandByAdmin = async (req, res) => {
  try {
    const landId = req.params?.id;
    const {
      city,
      area,
      parcelId,
      address,
      surveyNo,
      landPrice,
      wardNo,
      province,
      district,
      latitude,
      longitude,
    } = req.body;

    const existingLand = await Land.findById({ _id: landId }).lean();

    console.log(parcelId, existingLand?.area);

    const land = await Land.findByIdAndUpdate(
      { _id: landId },
      {
        city: city || existingLand.city,
        area: area || existingLand.area,
        parcelId: parcelId || existingLand?.parcelId,
        address: address || existingLand.address,
        wardNo: wardNo || existingLand.wardNo,
        province: province || existingLand.province,
        district: district || existingLand?.district,
        latitude: latitude || existingLand.latitude,
        longitude: longitude || existingLand.longitude,
        landPrice: landPrice || existingLand.landPrice,
        surveyNo: surveyNo || existingLand.surveyNo,
      },
      { new: true }
    ).lean();

    if (!land) {
      throw new SetErrorResponse("Land not found", 404);
    }

    return res.success({ landData: land }, "Land updated");
  } catch (err) {
    console.log(`Err :: ${err.message}`);
    return res.fail(err);
  }
};

exports.getAllLandsByAdmin = async (req, res) => {
  try {
    const {
      page,
      limit,
      search = "",
      sort,
      city,
      district,
      province,
    } = req?.query;

    let query = {};
    if (search) {
      query.parcelId = { $regex: search, $options: "i" };
    }
    if (city) {
      query.city = { $regex: city, $options: "i" };
    }
    if (district) {
      query.district = { $regex: district, $options: "i" };
    }
    if (province) {
      query.province = { $regex: province, $options: "i" };
    }
    query.isVerified = "pending";
    console.log(query, page);

    const lands = await getSearchPaginatedData({
      model: Land,
      reqQuery: {
        sort,
        page,
        limit,
        query,
        populate: [
          { path: "ownerUserId" },
          {
            path: "ownerHistory",
          },
        ],
        pagination: true,
        modFunction: (document) => {
          return document;
        },
      },
      search: search,
    });
    console.log(lands);

    if (!lands) {
      throw new SetErrorResponse("Land not found", 404);
    }
    return res.success({ landData: lands });
  } catch (err) {
    console.log(`Err get lands by admin : ${err}`);
    return res.fail(err);
  }
};
