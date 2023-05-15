const { default: mongoose } = require("mongoose");
const Land = require("../models/land.model");
const LandSale = require("../models/land.sale.model");
const TransferOwnership = require("../models/transfer.ownership.model");
const User = require("../models/user.model");
const { getSearchPaginatedData } = require("../utils/pagination");
const { SetErrorResponse } = require("../utils/responseSetter");
const {
  deleteFileCloudinary,
  deleteFileLocal,
} = require("../utils/fileHandling");

module.exports.getLandForTransferOwnershipById = async (req, res) => {
  var transferId = req.params.id;
  try {
    const transferData = await TransferOwnership.findById(transferId)
      .populate([
        {
          path: "approvedUserId.user",
        },
        {
          path: "ownerHistory",
        },
        {
          path: "landSaleId",
          populate: [
            {
              path: "landId",
            },
            {
              path: "geoJSON",
            },
            {
              path: "ownerUserId",
            },
          ],
        },
      ])
      .lean();

    console.log(transferData);

    if (!transferData) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }

    return res.success(transferData);
  } catch (err) {
    console.log(`Error from getLandForTransferOwnershipById : ${err}`);
    return res.fail(err);
  }
};

module.exports.getAllLandForTransferOwnership = async (req, res) => {
  var userId = req.params.id;
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
    let populateQuery = [];
    if (search) {
      populateQuery.push({ parcelId: { $regex: search, $options: "i" } });
    }
    if (city) {
      populateQuery.push({ city: { $regex: city, $options: "i" } });
    }
    if (district) {
      populateQuery.push({ district: { $regex: district, $options: "i" } });
    }
    if (province) {
      populateQuery.push({ province: { $regex: province, $options: "i" } });
    }

    query = {
      $and: [
        {
          $or: [
            { ownerUserId: userId },
            { "approvedUserId.user": userId },
            { ownerHistory: userId },
          ],
        },
        {
          $or: [
            { transerData: "pending" },
            { transerData: "ongoing" },
            { transerData: "initiated" },
            { transerData: "rejected" },
            { transerData: "completed" },
          ],
        },
      ],
    };
    console.log(query);

    const transferOwnership = await getSearchPaginatedData({
      model: TransferOwnership,
      reqQuery: {
        sort,
        page,
        limit,
        query,
        populate: [
          {
            path: "approvedUserId.user",
          },
          {
            path: "ownerHistory",
          },
          {
            path: "landSaleId",
            populate: [
              {
                path: "landId",
                match: populateQuery.length != 0 ? { $and: populateQuery } : {},
                // match: { ownerHistory: { $in: [userId] } },
              },
              {
                path: "geoJSON",
                match: populateQuery.length != 0 ? { $and: populateQuery } : {},
              },
              {
                path: "ownerUserId",
                match: populateQuery.length != 0 ? { $and: populateQuery } : {},
              },
            ],
          },
        ],
        pagination: true,
        modFunction: async (document) => {
          //   console.log(`document :: ${document}`);
          if (document.landSaleId.landId != null) {
            return document;
          }
        },
      },
    });

    console.log(transferOwnership);

    if (!transferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }

    return res.success(transferOwnership);
  } catch (err) {
    console.log(`Error from getAllLandForTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

module.exports.addLandForTransferOwnership = async (req, res) => {
  try {
    const landSaleId = req.params.id;

    const existingTransfer = await TransferOwnership.findOne({
      landSaleId: landSaleId,
    }).lean();
    if (existingTransfer) {
      throw new SetErrorResponse("Already exist", 403);
    }

    const landSale = await LandSale.findById({ _id: landSaleId })
      .populate({ path: "landId ownerUserId" })
      .lean();

    console.log(landSale);

    if (!landSale) {
      throw new SetErrorResponse("LandSale not found", 404);
    }

    if (landSale?.ownerUserId._id != res.locals.authData?._id) {
      throw new SetErrorResponse(
        "User have no permission to add land for transfer",
        401
      );
    }

    await LandSale.findByIdAndUpdate(
      { _id: landSaleId },
      {
        saleData: "transferring",
      },
      { new: true }
    )
      .populate({ path: "landId ownerUserId" })
      .lean();

    const newTransfer = new TransferOwnership({
      landSaleId,
      ownerUserId: res.locals.authData?._id,
      approvedUserId: {
        user: landSale?.approvedUserId?.user,
        landPrice: landSale?.approvedUserId?.landPrice,
      },
    });

    await newTransfer.save();

    return res.success(
      { transferOwnershipData: newTransfer },
      "Land added for transfer"
    );
  } catch (err) {
    console.log(`Error from addLandForTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

module.exports.addPaymentFormForLandTransferOwnership = async (req, res) => {
  try {
    const landTransferId = req.params.id;
    const { billToken, sellerBankAcc, buyerBankAcc, transactionAmt } = req.body;

    const existingTransfer = await TransferOwnership.findById({
      _id: landTransferId,
    }).lean();
    if (!existingTransfer) {
      throw new SetErrorResponse("Not Found!!!", 403);
    }

    const updatedTranferOwnership = await TransferOwnership.findByIdAndUpdate(
      { _id: landTransferId },
      {
        transerData: "ongoing",
        buyerBankAcc,
        sellerBankAcc,
        transactionAmt,
        billToken,
      },
      { new: true }
    ).lean();

    return res.success(
      { transferOwnershipData: updatedTranferOwnership },
      "Payment form successfully"
    );
  } catch (err) {
    console.log(`Error from addPaymentFormForLandTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

module.exports.patchPaymentVoucherLandTransferOwnership = async (req, res) => {
  try {
    const landTransferId = req.params.id;
    const voucherFormImageLocation =
      req.files?.voucherFormImage?.length > 0
        ? req.files.voucherFormImage[0]?.location
        : undefined;

    var editBackQuery = {};

    if (voucherFormImageLocation) {
      editBackQuery = {
        voucherFormFile: {},
      };
      editBackQuery.voucherFormFile.voucherFormImage = voucherFormImageLocation;
      editBackQuery.voucherFormFile.voucherFormPublicId =
        req.files?.voucherFormImage[0]?.publicId;
    }

    TransferOwnership.findById({ _id: landTransferId })
      .lean()
      .then(async (res) => {
        console.log(res.voucherFormFile?.voucherFormPublicId);
        if (
          voucherFormImageLocation &&
          res.voucherFormFile?.voucherFormPublicId
        ) {
          await deleteFileCloudinary(res.voucherFormFile?.voucherFormPublicId);
        }
      })
      .catch((err) => {
        throw new SetErrorResponse("Error deleting file cloudinary", 500);
      });

    const updatedTranferOwnership = await TransferOwnership.findOneAndUpdate(
      { _id: landTransferId },
      {
        ...editBackQuery,
      },
      { new: true }
    ).lean();

    if (
      voucherFormImageLocation &&
      updatedTranferOwnership?.voucherFormFile?.voucherFormPublicId
    ) {
      deleteFileLocal({ imagePath: req.files.voucherFormImage[0]?.path });
    }

    if (!updatedTranferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found"); // default (Not found,404)
    }

    return res.success(
      { transferOwnershipData: updatedTranferOwnership },
      "Success"
    );
  } catch (err) {
    res.fail(err);
  }
};

module.exports.initiateTransferForLandTransferOwnership = async (req, res) => {
  try {
    const landTransferId = req.params.id;

    const existingTransfer = await TransferOwnership.findById({
      _id: landTransferId,
    }).lean();
    if (!existingTransfer) {
      throw new SetErrorResponse("Not Found!!!", 403);
    }
    if (existingTransfer?.transerData == "initiated") {
      throw new SetErrorResponse("ALready initiated!!!", 401);
    }

    const updatedTranferOwnership = await TransferOwnership.findByIdAndUpdate(
      { _id: landTransferId },
      {
        transerData: "initiated",
      },
      { new: true }
    ).lean();

    return res.success(
      { transferOwnershipData: updatedTranferOwnership },
      "Land initiated successfully"
    );
  } catch (err) {
    console.log(`Error from initiateTransferForLandTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

// Admin ----------------------------------------------------------------
module.exports.approveLandForTransferOwnership = async (req, res) => {
  try {
    const transferOwnershipId = req.params.id;
    const transferOwnership = await TransferOwnership.findById({
      _id: transferOwnershipId,
    })
      .populate([
        {
          path: "approvedUserId.user",
        },
        {
          path: "landSaleId",
          populate: {
            path: "landId ownerUserId",
          },
        },
      ])
      .lean();

    if (!transferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }
    if (transferOwnership?.transerData != "initiated") {
      throw new SetErrorResponse(
        "Land is not initiated for transfer ownership",
        401
      );
    }

    let ownerHistory = [];
    let land = [];
    ownerHistory.push(transferOwnership?.ownerUserId);
    land.push(transferOwnership?.landSaleId?.landId?._id);

    const [
      updatedUser,
      updatedLand,
      updatedLandSale,
      updatedTransferOwnership,
    ] = await Promise.all([
      User.findByIdAndUpdate(
        { _id: transferOwnership?.approvedUserId.user?._id },
        { ownedLand: [...land] },
        { new: true }
      ).lean(),
      Land.findByIdAndUpdate(
        { _id: transferOwnership?.landSaleId?.landId?._id },
        {
          ownerUserId: transferOwnership?.approvedUserId?.user?._id,
          ownerHistory: [...ownerHistory],
          saleData: null,
        },
        { new: true }
      ).lean(),
      LandSale.findByIdAndUpdate(
        { _id: transferOwnership?.landSaleId?._id },
        {
          ownerUserId: transferOwnership?.approvedUserId?.user?._id,
          prevOwnerUserId: transferOwnership?.ownerUserId,
          saleData: "selled",
        },
        { new: true }
      ).lean(),
      TransferOwnership.findByIdAndUpdate(
        {
          _id: transferOwnershipId,
        },
        {
          transerData: "completed",
          ownerUserId: transferOwnership?.approvedUserId?.user?._id,
        },
        { new: true }
      ).lean(),
    ]);

    // const updatedLand = await Land.findByIdAndUpdate(
    //   { _id: transferOwnership?.landSaleId?.landId },
    //   {
    //     ownerUserId: transferOwnership?.approvedUserId,
    //     ownerHistory: [...res.locals.authData?._id],
    //   },
    //   { new: true }
    // ).lean();

    console.log(`updatedLand : ${updatedLand}`);
    // console.log(updatedLandSale);
    // console.log(updatedTransferOwnership);

    // const updatedLandSale = await LandSale.findByIdAndUpdate(
    //   { _id: transferOwnership?.landSaleId },
    //   {
    //     ownerUserId: transferOwnership?.approvedUserId,
    //     prevOwnerUserId: res.locals.authData?._id,
    //     saleData: "selled",
    //   },
    //   { new: true }
    // ).lean();

    // const updatedTranferOwnership = await TransferOwnership.findByIdAndUpdate(
    //   {
    //     _id: transferOwnershipId,
    //   },
    //   {
    //     ownerUserId: transferOwnership?.approvedUserId,
    //   },
    //   { new: true }
    // ).lean();

    return res.success(
      { transferOwnershipData: updatedTransferOwnership },
      "Land approved for transfer"
    );
  } catch (err) {
    console.log(`Error from approveLandForTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

module.exports.rejectLandForTransferOwnership = async (req, res) => {
  try {
    const transferOwnershipId = req.params.id;
    const transferOwnership = await TransferOwnership.findById({
      _id: transferOwnershipId,
    })
      .populate({
        path: "landSaleId",
        populate: {
          path: "landId ownerUserId",
        },
      })
      .lean();

    if (!transferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }
    if (transferOwnership?.ownerUserId._id != res.locals.authData?._id) {
      throw new SetErrorResponse(
        "User have no permission to approve land for transfer",
        401
      );
    }

    let rejectedUserId = [];
    rejectedUserId.push(transferOwnership?.approvedUserId);

    const [updatedLand, updatedLandSale, updatedTransferOwnership] =
      await Promise.all([
        LandSale.findByIdAndUpdate(
          { _id: transferOwnership?.landSaleId?._id },
          {
            approvedUserId: {},
            saleData: "rejected",
            rejectedUserId: [],
          },
          { new: true }
        ).lean(),
        TransferOwnership.findByIdAndUpdate(
          {
            _id: transferOwnershipId,
          },
          { approvedUserId: {}, transerData: "rejected" },
          { new: true }
        ).lean(),
      ]);

    return res.success(
      { transferOwnershipData: updatedTransferOwnership },
      "Land added for transfer"
    );
  } catch (err) {
    console.log(`Error from rejectLandForTransferOwnership : ${err}`);
    return res.fail(err);
  }
};

module.exports.getAllLandTransferOwnershipByAdmin = async (req, res) => {
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
    let populateQuery = [];
    if (search) {
      populateQuery.push({ parcelId: { $regex: search, $options: "i" } });
    }
    if (city) {
      populateQuery.push({ city: { $regex: city, $options: "i" } });
    }
    if (district) {
      populateQuery.push({ district: { $regex: district, $options: "i" } });
    }
    if (province) {
      populateQuery.push({ province: { $regex: province, $options: "i" } });
    }

    query = { transerData: "initiated" };
    console.log(query);

    const transferOwnership = await getSearchPaginatedData({
      model: TransferOwnership,
      reqQuery: {
        sort,
        page,
        limit,
        query,
        populate: [
          {
            path: "approvedUserId.user",
          },
          {
            path: "ownerHistory",
          },
          {
            path: "ownerUserId",
          },
          {
            path: "landSaleId",
            populate: [
              {
                path: "landId",
                match: populateQuery.length != 0 ? { $and: populateQuery } : {},
                // match: { ownerHistory: { $in: [userId] } },
              },
              {
                path: "geoJSON",
                match: populateQuery.length != 0 ? { $and: populateQuery } : {},
              },
              // {
              //   path: "ownerUserId",
              //   match: populateQuery.length != 0 ? { $and: populateQuery } : {},
              // },
            ],
          },
        ],
        pagination: true,
        modFunction: async (document) => {
          //   console.log(`document :: ${document}`);
          if (document.landSaleId.landId != null) {
            return document;
          }
        },
      },
    });

    console.log(transferOwnership);

    if (!transferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }

    return res.success(transferOwnership);
  } catch (err) {
    console.log(`Error from getAllLandTransferOwnershipByAdmin : ${err}`);
    return res.fail(err);
  }
};

module.exports.cancelLandTransferOwnershipByAdmin = async (req, res) => {
  try {
    const transferOwnershipId = req.params.id;
    const transferOwnership = await TransferOwnership.findById({
      _id: transferOwnershipId,
    })
      .populate({
        path: "landSaleId",
        populate: {
          path: "landId ownerUserId",
        },
      })
      .lean();

    console.log(transferOwnership.landSaleId.landId._id);

    if (!transferOwnership) {
      throw new SetErrorResponse("TransferOwnership not found", 404);
    }

    await Promise.all([
      LandSale.findByIdAndRemove({
        _id: transferOwnership?.landSaleId?._id,
      }).lean(),
      TransferOwnership.findByIdAndRemove({
        _id: transferOwnershipId,
      }).lean(),
      Land.findByIdAndUpdate(
        {
          _id: transferOwnership?.landSaleId?.landId._id,
        },
        {
          saleData: "null",
        },
        { new: true }
      ).lean(),
    ]);

    return res.success({}, "Land cancelled for transfer");
  } catch (err) {
    console.log(`Error from cancelLandTransferOwnershipByAdmin : ${err}`);
    return res.fail(err);
  }
};
//----------------------------------------------------------------
