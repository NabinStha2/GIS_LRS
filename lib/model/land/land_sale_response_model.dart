// To parse this JSON data, do
//
//     final landSaleResponseModel = landSaleResponseModelFromJson(jsonString);

import 'dart:convert';

import '../land_response_model.dart';
import 'individual_land_sale_response_model.dart';

LandSaleResponseModel landSaleResponseModelFromJson(String str) =>
    LandSaleResponseModel.fromJson(json.decode(str));

String landSaleResponseModelToJson(LandSaleResponseModel data) =>
    json.encode(data.toJson());

class LandSaleResponseModel {
  LandSaleResponseModel({
    this.data,
  });

  LandSaleResponseData? data;

  factory LandSaleResponseModel.fromJson(Map<String, dynamic> json) =>
      LandSaleResponseModel(
        data: json["data"] == null
            ? null
            : LandSaleResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class LandSaleResponseData {
  LandSaleResponseData({
    this.landSaleData,
  });

  LandSaleData? landSaleData;

  factory LandSaleResponseData.fromJson(Map<String, dynamic> json) =>
      LandSaleResponseData(
        landSaleData: json["landSaleData"] == null
            ? null
            : LandSaleData.fromJson(json["landSaleData"]),
      );

  Map<String, dynamic> toJson() => {
        "landSaleData": landSaleData?.toJson(),
      };
}

class LandSaleData {
  LandSaleData({
    this.count,
    this.totalPages,
    this.currentPageNumber,
    this.results,
  });

  int? count;
  int? totalPages;
  int? currentPageNumber;
  List<LandSaleResult>? results;

  factory LandSaleData.fromJson(Map<String, dynamic> json) => LandSaleData(
        count: json["count"],
        totalPages: json["totalPages"],
        currentPageNumber: json["currentPageNumber"],
        results: json["results"] == null
            ? []
            : List<LandSaleResult>.from(
                json["results"]!.map((x) => LandSaleResult.fromJson(x))),
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

class LandSaleResult {
  LandSaleResult({
    this.id,
    this.landId,
    this.parcelId,
    this.ownerUserId,
    this.saleData,
    this.requestedUserId,
    this.rejectedUserId,
    this.v,
    this.approvedUserId,
    this.prevOwnerUserId,
    this.geoJson,
  });

  String? id;
  LandId? landId;
  String? parcelId;
  UserId? ownerUserId;
  String? saleData;
  List<UserId>? requestedUserId;
  List<UserId>? rejectedUserId;
  int? v;
  UserId? approvedUserId;
  UserId? prevOwnerUserId;
  GeoJson? geoJson;

  factory LandSaleResult.fromJson(Map<String, dynamic> json) => LandSaleResult(
        id: json["_id"],
        landId: json["landId"] == null ? null : LandId.fromJson(json["landId"]),
        parcelId: json["parcelId"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        saleData: json["saleData"],
        requestedUserId: json["requestedUserId"] == null
            ? []
            : List<UserId>.from(
                json["requestedUserId"]!.map((x) => UserId.fromJson(x))),
        rejectedUserId: json["rejectedUserId"] == null
            ? []
            : List<UserId>.from(
                json["rejectedUserId"]!.map((x) => UserId.fromJson(x))),
        v: json["__v"],
        approvedUserId: json["approvedUserId"] == null
            ? null
            : UserId.fromJson(json["approvedUserId"]),
        prevOwnerUserId: json["prevOwnerUserId"] == null
            ? null
            : UserId.fromJson(json["prevOwnerUserId"]),
        geoJson:
            json["geoJSON"] == null ? null : GeoJson.fromJson(json["geoJSON"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "landId": landId?.toJson(),
        "parcelId": parcelId,
        "ownerUserId": ownerUserId,
        "saleData": saleData,
        "requestedUserId": requestedUserId == null
            ? []
            : List<dynamic>.from(requestedUserId!.map((x) => x)),
        "rejectedUserId": rejectedUserId == null
            ? []
            : List<dynamic>.from(rejectedUserId!.map((x) => x)),
        "__v": v,
        "approvedUserId": approvedUserId,
        "prevOwnerUserId": prevOwnerUserId,
        "geoJSON": geoJson?.toJson(),
      };
}

// class LandId {
//   LandId({
//     this.id,
//     this.city,
//     this.area,
//     this.latitude,
//     this.longitude,
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
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.polygon,
//   });

//   String? id;
//   String? city;
//   String? area;
//   String? latitude;
//   String? longitude;
//   String? parcelId;
//   String? wardNo;
//   String? district;
//   String? address;
//   String? surveyNo;
//   String? province;
//   String? landPrice;
//   String? isVerified;
//   String? ownerUserId;
//   List<String>? ownerHistory;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//   List<Polygon>? polygon;

//   factory LandId.fromJson(Map<String, dynamic> json) => LandId(
//         id: json["_id"],
//         city: json["city"],
//         area: json["area"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
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
//             : List<String>.from(json["ownerHistory"]!.map((x) => x)),
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         polygon: json["polygon"] == null
//             ? []
//             : List<Polygon>.from(
//                 json["polygon"]!.map((x) => Polygon.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "city": city,
//         "area": area,
//         "latitude": latitude,
//         "longitude": longitude,
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
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "polygon": polygon == null
//             ? []
//             : List<dynamic>.from(polygon!.map((x) => x.toJson())),
//       };
// }

// class Polygon {
//   Polygon({
//     this.latitude,
//     this.longitude,
//     this.id,
//   });

//   String? latitude;
//   String? longitude;
//   String? id;

//   factory Polygon.fromJson(Map<String, dynamic> json) => Polygon(
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         id: json["_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "latitude": latitude,
//         "longitude": longitude,
//         "_id": id,
//       };
// }

// class OwnerUserId {
//   OwnerUserId({
//     this.frontCitizenshipFile,
//     this.id,
//     this.email,
//     this.firstName,
//     this.lastName,
//     this.address,
//     this.phoneNumber,
//     this.isVerified,
//     this.ownedLand,
//     this.nameTg,
//     this.name,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.imageFile,
//     this.backCitizenshipFile,
//   });

//   FrontCitizenshipFile? frontCitizenshipFile;
//   String? id;
//   String? email;
//   String? firstName;
//   String? lastName;
//   String? address;
//   String? phoneNumber;
//   String? isVerified;
//   List<String>? ownedLand;
//   List<String>? nameTg;
//   String? name;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//   ImageFile? imageFile;
//   BackCitizenshipFile? backCitizenshipFile;

//   factory OwnerUserId.fromJson(Map<String, dynamic> json) => OwnerUserId(
//         frontCitizenshipFile: json["frontCitizenshipFile"] == null
//             ? null
//             : FrontCitizenshipFile.fromJson(json["frontCitizenshipFile"]),
//         id: json["_id"],
//         email: json["email"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         address: json["address"],
//         phoneNumber: json["phoneNumber"],
//         isVerified: json["isVerified"],
//         ownedLand: json["ownedLand"] == null
//             ? []
//             : List<String>.from(json["ownedLand"]!.map((x) => x)),
//         nameTg: json["name_tg"] == null
//             ? []
//             : List<String>.from(json["name_tg"]!.map((x) => x)),
//         name: json["name"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         imageFile: json["imageFile"] == null
//             ? null
//             : ImageFile.fromJson(json["imageFile"]),
//         backCitizenshipFile: json["backCitizenshipFile"] == null
//             ? null
//             : BackCitizenshipFile.fromJson(json["backCitizenshipFile"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "frontCitizenshipFile": frontCitizenshipFile?.toJson(),
//         "_id": id,
//         "email": email,
//         "firstName": firstName,
//         "lastName": lastName,
//         "address": address,
//         "phoneNumber": phoneNumber,
//         "isVerified": isVerified,
//         "ownedLand": ownedLand == null
//             ? []
//             : List<dynamic>.from(ownedLand!.map((x) => x)),
//         "name_tg":
//             nameTg == null ? [] : List<dynamic>.from(nameTg!.map((x) => x)),
//         "name": name,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "imageFile": imageFile?.toJson(),
//         "backCitizenshipFile": backCitizenshipFile?.toJson(),
//       };
// }

// class BackCitizenshipFile {
//   BackCitizenshipFile({
//     this.backCitizenshipImage,
//     this.backCitizenshipPublicId,
//   });

//   String? backCitizenshipImage;
//   String? backCitizenshipPublicId;

//   factory BackCitizenshipFile.fromJson(Map<String, dynamic> json) =>
//       BackCitizenshipFile(
//         backCitizenshipImage: json["backCitizenshipImage"],
//         backCitizenshipPublicId: json["backCitizenshipPublicId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "backCitizenshipImage": backCitizenshipImage,
//         "backCitizenshipPublicId": backCitizenshipPublicId,
//       };
// }

// class FrontCitizenshipFile {
//   FrontCitizenshipFile({
//     this.frontCitizenshipImage,
//     this.frontCitizenshipPublicId,
//   });

//   String? frontCitizenshipImage;
//   String? frontCitizenshipPublicId;

//   factory FrontCitizenshipFile.fromJson(Map<String, dynamic> json) =>
//       FrontCitizenshipFile(
//         frontCitizenshipImage: json["frontCitizenshipImage"],
//         frontCitizenshipPublicId: json["frontCitizenshipPublicId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "frontCitizenshipImage": frontCitizenshipImage,
//         "frontCitizenshipPublicId": frontCitizenshipPublicId,
//       };
// }

// class ImageFile {
//   ImageFile({
//     this.imageUrl,
//     this.imagePublicId,
//   });

//   String? imageUrl;
//   String? imagePublicId;

//   factory ImageFile.fromJson(Map<String, dynamic> json) => ImageFile(
//         imageUrl: json["imageUrl"],
//         imagePublicId: json["imagePublicId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "imageUrl": imageUrl,
//         "imagePublicId": imagePublicId,
//       };
// }
