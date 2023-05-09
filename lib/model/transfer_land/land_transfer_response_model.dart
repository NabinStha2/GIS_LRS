// To parse this JSON data, do
//
//     final landTransferResponseModel = landTransferResponseModelFromJson(jsonString);

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
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  LandTransferDataResult({
    this.id,
    this.landSaleId,
    this.ownerUserId,
    this.approvedUserId,
    this.transerData,
    this.createdAt,
    this.updatedAt,
    this.v,
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
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "landSaleId": landSaleId?.toJson(),
        "ownerUserId": ownerUserId,
        "approvedUserId": approvedUserId?.toJson(),
        "transerData": transerData,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
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
  });

  factory LandSaleId.fromJson(Map<String, dynamic> json) => LandSaleId(
        id: json["_id"],
        landId: json["landId"] == null ? null : LandId.fromJson(json["landId"]),
        parcelId: json["parcelId"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        geoJson:
            json["geoJSON"] == null ? null : GeoJson.fromJson(json["geoJSON"]),
        requestedUserId: json["requestedUserId"] == null
            ? []
            : List<dynamic>.from(json["requestedUserId"]!.map((x) => x)),
        rejectedUserId: json["rejectedUserId"] == null
            ? []
            : List<dynamic>.from(json["rejectedUserId"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        approvedUserId: json["approvedUserId"],
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
        "geoJSON": geoJson,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "approvedUserId": approvedUserId,
      };
}

// class LandId {
//   String? id;
//   String? city;
//   String? area;
//   String? parcelId;
//   String? wardNo;
//   String? district;
//   String? address;
//   String? surveyNo;
//   String? province;
//   String? landPrice;
//   String? isVerified;
//   String? ownerUserId;
//   List<dynamic>? ownerHistory;
//   String? saleData;
//   String? geoJson;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;

//   LandId({
//     this.id,
//     this.city,
//     this.area,
//     this.parcelId,
//     this.wardNo,
//     this.district,
//     this.address,
//     this.surveyNo,
//     this.province,
//     this.landPrice,
//     this.isVerified,
//     this.ownerUserId,
//     this.ownerHistory,
//     this.saleData,
//     this.geoJson,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory LandId.fromJson(Map<String, dynamic> json) => LandId(
//         id: json["_id"],
//         city: json["city"],
//         area: json["area"],
//         parcelId: json["parcelId"],
//         wardNo: json["wardNo"],
//         district: json["district"],
//         address: json["address"],
//         surveyNo: json["surveyNo"],
//         province: json["province"],
//         landPrice: json["landPrice"],
//         isVerified: json["isVerified"],
//         ownerUserId: json["ownerUserId"],
//         ownerHistory: json["ownerHistory"] == null
//             ? []
//             : List<dynamic>.from(json["ownerHistory"]!.map((x) => x)),
//         saleData: json["saleData"],
//         geoJson: json["geoJSON"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "city": city,
//         "area": area,
//         "parcelId": parcelId,
//         "wardNo": wardNo,
//         "district": district,
//         "address": address,
//         "surveyNo": surveyNo,
//         "province": province,
//         "landPrice": landPrice,
//         "isVerified": isVerified,
//         "ownerUserId": ownerUserId,
//         "ownerHistory": ownerHistory == null
//             ? []
//             : List<dynamic>.from(ownerHistory!.map((x) => x)),
//         "saleData": saleData,
//         "geoJSON": geoJson,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//       };
// }
