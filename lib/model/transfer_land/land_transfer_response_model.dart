import 'dart:convert';

import '../land/individual_land_sale_response_model.dart';
import '../land_response_model.dart';

LandTransferResponseModel landTransferResponseModelFromJson(String str) =>
    LandTransferResponseModel.fromJson(json.decode(str));

String landTransferResponseModelToJson(LandTransferResponseModel data) =>
    json.encode(data.toJson());

class LandTransferResponseModel {
  LandTransferData? data;

  LandTransferResponseModel({
    this.data,
  });

  factory LandTransferResponseModel.fromJson(Map<String, dynamic> json) =>
      LandTransferResponseModel(
        data: json["data"] == null
            ? null
            : LandTransferData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class LandTransferData {
  int? count;
  int? totalPages;
  int? currentPageNumber;
  List<LandTransferDataResult>? results;

  LandTransferData({
    this.count,
    this.totalPages,
    this.currentPageNumber,
    this.results,
  });

  factory LandTransferData.fromJson(Map<String, dynamic> json) =>
      LandTransferData(
        count: json["count"],
        totalPages: json["totalPages"],
        currentPageNumber: json["currentPageNumber"],
        results: json["results"] == null
            ? []
            : List<LandTransferDataResult>.from(json["results"]!
                .map((x) => LandTransferDataResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "totalPages": totalPages,
        "currentPageNumber": currentPageNumber,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class LandTransferDataResult {
  String? id;
  LandSaleId? landSaleId;
  String? ownerUserId;
  UserId? approvedUserId;
  String? transerData;
  int? transactionAmt;
  DateTime? transactionDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? billToken;
  String? buyerBankAcc;
  String? sellerBankAcc;
  UserId? ownerHistory;
  VoucherFormFile? voucherFormFile;

  LandTransferDataResult({
    this.id,
    this.landSaleId,
    this.ownerUserId,
    this.approvedUserId,
    this.transerData,
    this.transactionAmt,
    this.transactionDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.billToken,
    this.buyerBankAcc,
    this.sellerBankAcc,
    this.ownerHistory,
    this.voucherFormFile,
  });

  factory LandTransferDataResult.fromJson(Map<String, dynamic> json) =>
      LandTransferDataResult(
        id: json["_id"],
        landSaleId: json["landSaleId"] == null
            ? null
            : LandSaleId.fromJson(json["landSaleId"]),
        ownerUserId: json["ownerUserId"],
        approvedUserId: json["approvedUserId"] == null
            ? null
            : UserId.fromJson(json["approvedUserId"]),
        transerData: json["transerData"],
        transactionAmt: json["transactionAmt"],
        transactionDate: json["transactionDate"] == null
            ? null
            : DateTime.parse(json["transactionDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        billToken: json["billToken"],
        buyerBankAcc: json["buyerBankAcc"],
        sellerBankAcc: json["sellerBankAcc"],
        ownerHistory: json["ownerHistory"] == null
            ? null
            : UserId.fromJson(json["ownerHistory"]),
        voucherFormFile: json["voucherFormFile"] == null
            ? null
            : VoucherFormFile.fromJson(json["voucherFormFile"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "landSaleId": landSaleId?.toJson(),
        "ownerUserId": ownerUserId,
        "approvedUserId": approvedUserId?.toJson(),
        "transerData": transerData,
        "transactionAmt": transactionAmt,
        "transactionDate": transactionDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "billToken": billToken,
        "buyerBankAcc": buyerBankAcc,
        "sellerBankAcc": sellerBankAcc,
        "ownerHistory": ownerHistory?.toJson(),
        "voucherFormFile": voucherFormFile?.toJson(),
      };
}

class VoucherFormFile {
  String? voucherFormImage;
  String? voucherFormPublicId;

  VoucherFormFile({
    this.voucherFormImage,
    this.voucherFormPublicId,
  });

  factory VoucherFormFile.fromJson(Map<String, dynamic> json) =>
      VoucherFormFile(
        voucherFormImage: json["voucherFormImage"],
        voucherFormPublicId: json["voucherFormPublicId"],
      );

  Map<String, dynamic> toJson() => {
        "voucherFormImage": voucherFormImage,
        "voucherFormPublicId": voucherFormPublicId,
      };
}

class LandSaleId {
  String? id;
  LandId? landId;
  String? parcelId;
  UserId? ownerUserId;
  String? saleData;
  List<dynamic>? requestedUserId;
  List<dynamic>? rejectedUserId;
  GeoJson? geoJson;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? approvedUserId;
  String? prevOwnerUserId;

  LandSaleId({
    this.id,
    this.landId,
    this.parcelId,
    this.ownerUserId,
    this.saleData,
    this.requestedUserId,
    this.rejectedUserId,
    this.geoJson,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.approvedUserId,
    this.prevOwnerUserId,
  });

  factory LandSaleId.fromJson(Map<String, dynamic> json) => LandSaleId(
        id: json["_id"],
        landId: json["landId"] == null ? null : LandId.fromJson(json["landId"]),
        parcelId: json["parcelId"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        saleData: json["saleData"],
        requestedUserId: json["requestedUserId"] == null
            ? []
            : List<dynamic>.from(json["requestedUserId"]!.map((x) => x)),
        rejectedUserId: json["rejectedUserId"] == null
            ? []
            : List<dynamic>.from(json["rejectedUserId"]!.map((x) => x)),
        geoJson:
            json["geoJSON"] == null ? null : GeoJson.fromJson(json["geoJSON"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        approvedUserId: json["approvedUserId"],
        prevOwnerUserId: json["prevOwnerUserId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "landId": landId?.toJson(),
        "parcelId": parcelId,
        "ownerUserId": ownerUserId?.toJson(),
        "saleData": saleData,
        "requestedUserId": requestedUserId == null
            ? []
            : List<dynamic>.from(requestedUserId!.map((x) => x)),
        "rejectedUserId": rejectedUserId == null
            ? []
            : List<dynamic>.from(rejectedUserId!.map((x) => x)),
        "geoJSON": geoJson?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "approvedUserId": approvedUserId,
        "prevOwnerUserId": prevOwnerUserId,
      };
}
