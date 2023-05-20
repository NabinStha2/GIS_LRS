import 'dart:convert';

import '../land_response_model.dart';
import 'individual_land_sale_response_model.dart';

IndividualLandResponseModel individualLandResponseModelFromJson(String str) =>
    IndividualLandResponseModel.fromJson(json.decode(str));

String individualLandResponseModelToJson(IndividualLandResponseModel data) =>
    json.encode(data.toJson());

class IndividualLandResponseModel {
  IndividualLandResponseModel({
    this.data,
  });

  Data? data;

  factory IndividualLandResponseModel.fromJson(Map<String, dynamic> json) =>
      IndividualLandResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.landData,
  });

  IndividualLandData? landData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        landData: json["landData"] == null
            ? null
            : IndividualLandData.fromJson(json["landData"]),
      );

  Map<String, dynamic> toJson() => {
        "landData": landData?.toJson(),
      };
}

class IndividualLandData {
  IndividualLandData({
    this.id,
    this.city,
    this.area,
    this.parcelId,
    this.wardNo,
    this.district,
    this.mapSheetNo,
    this.street,
    this.province,
    this.landPrice,
    this.isVerified,
    this.ownerUserId,
    this.ownerHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.saleData,
    this.geoJson,
    this.landSaleId,
  });

  String? id;
  String? city;
  String? area;
  String? parcelId;
  String? wardNo;
  String? district;
  String? mapSheetNo;
  String? street;
  String? province;
  String? landPrice;
  String? isVerified;
  UserId? ownerUserId;
  List<dynamic>? ownerHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? saleData;
  String? landSaleId;
  GeoJson? geoJson;

  factory IndividualLandData.fromJson(Map<String, dynamic> json) =>
      IndividualLandData(
        id: json["_id"],
        geoJson:
            json["geoJSON"] == null ? null : GeoJson.fromJson(json["geoJSON"]),
        city: json["city"],
        area: json["area"],
        parcelId: json["parcelId"],
        wardNo: json["wardNo"],
        district: json["district"],
        street: json["street"],
        mapSheetNo: json["mapSheetNo"],
        province: json["province"],
        landPrice: json["landPrice"],
        isVerified: json["isVerified"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        ownerHistory: json["ownerHistory"] == null
            ? []
            : List<dynamic>.from(json["ownerHistory"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        saleData: json["saleData"],
        landSaleId: json["landSaleId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "city": city,
        "area": area,
        "parcelId": parcelId,
        "wardNo": wardNo,
        "district": district,
        // "address": address,
        // "surveyNo": surveyNo,
        "province": province,
        "landPrice": landPrice,
        "isVerified": isVerified,
        "ownerUserId": ownerUserId?.toJson(),
        "ownerHistory": ownerHistory == null
            ? []
            : List<dynamic>.from(ownerHistory!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "saleData": saleData,
        "landSaleId": landSaleId,
      };
}

// class UserId {
//   UserId({
//     this.id,
//     this.email,
//     this.firstName,
//     this.lastName,
//     this.address,
//     this.phoneNumber,
//     this.isVerified,
//     this.ownedLand,
//     this.name,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.frontCitizenshipFile,
//     this.imageFile,
//     this.backCitizenshipFile,
//   });

//   String? id;
//   String? email;
//   String? firstName;
//   String? lastName;
//   String? address;
//   String? phoneNumber;
//   String? isVerified;
//   List<String>? ownedLand;
//   String? name;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//   FrontCitizenshipFile? frontCitizenshipFile;
//   ImageFile? imageFile;
//   BackCitizenshipFile? backCitizenshipFile;

//   factory UserId.fromJson(Map<String, dynamic> json) => UserId(
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
//         name: json["name"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         frontCitizenshipFile: json["frontCitizenshipFile"] == null
//             ? null
//             : FrontCitizenshipFile.fromJson(json["frontCitizenshipFile"]),
//         imageFile: json["imageFile"] == null
//             ? null
//             : ImageFile.fromJson(json["imageFile"]),
//         backCitizenshipFile: json["backCitizenshipFile"] == null
//             ? null
//             : BackCitizenshipFile.fromJson(json["backCitizenshipFile"]),
//       );

//   Map<String, dynamic> toJson() => {
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
//         "name": name,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "frontCitizenshipFile": frontCitizenshipFile?.toJson(),
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
