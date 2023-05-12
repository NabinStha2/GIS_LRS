import 'dart:convert';

import '../land_response_model.dart';

IndividualLandSaleResponseModel individualLandSaleResponseModelFromJson(
        String str) =>
    IndividualLandSaleResponseModel.fromJson(json.decode(str));

String individualLandSaleResponseModelToJson(
        IndividualLandSaleResponseModel data) =>
    json.encode(data.toJson());

class IndividualLandSaleResponseModel {
  IndividualLandSaleResponseModel({
    this.data,
  });

  Data? data;

  factory IndividualLandSaleResponseModel.fromJson(Map<String, dynamic> json) =>
      IndividualLandSaleResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.landSaleData,
  });

  IndividualLandSaleData? landSaleData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        landSaleData: json["landSaleData"] == null
            ? null
            : IndividualLandSaleData.fromJson(json["landSaleData"]),
      );

  Map<String, dynamic> toJson() => {
        "landSaleData": landSaleData?.toJson(),
      };
}

class IndividualLandSaleData {
  IndividualLandSaleData({
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
    this.landPrice,
  });

  String? id;
  LandId? landId;
  String? parcelId;
  UserId? ownerUserId;
  String? saleData;
  UserDataResultsProperties? approvedUserId;
  List<UserDataResultsProperties>? requestedUserId;
  List<UserDataResultsProperties>? rejectedUserId;
  UserId? prevOwnerUserId;
  GeoJson? geoJson;
  String? landPrice;
  int? v;

  factory IndividualLandSaleData.fromJson(Map<String, dynamic> json) =>
      IndividualLandSaleData(
        id: json["_id"],
        landId: json["landId"] == null ? null : LandId.fromJson(json["landId"]),
        parcelId: json["parcelId"],
        landPrice: json["landPrice"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        approvedUserId: json["approvedUserId"] == null
            ? null
            : UserDataResultsProperties.fromJson(json["approvedUserId"]),
        saleData: json["saleData"],
        requestedUserId: json["requestedUserId"] == null
            ? []
            : List<UserDataResultsProperties>.from(json["requestedUserId"]!
                .map((x) => UserDataResultsProperties.fromJson(x))),
        rejectedUserId: json["rejectedUserId"] == null
            ? []
            : List<UserDataResultsProperties>.from(json["rejectedUserId"]!
                .map((x) => UserDataResultsProperties.fromJson(x))),

        // requestedUserId: json["requestedUserId"] == null
        //     ? []
        //     : List<UserId>.from(
        //         json["requestedUserId"]!.map((x) => UserId.fromJson(x))),
        // rejectedUserId: json["rejectedUserId"] == null
        //     ? []
        //     : List<UserId>.from(
        //         json["rejectedUserId"]!.map((x) => UserId.fromJson(x))),
        // v: json["__v"],
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
        "ownerUserId": ownerUserId?.toJson(),
        "approvedUserId": approvedUserId?.toJson(),
        "saleData": saleData,
        "requestedUserId": requestedUserId == null
            ? []
            : List<UserId>.from(requestedUserId!.map((x) => x.toJson())),
        "rejectedUserId": rejectedUserId == null
            ? []
            : List<UserId>.from(rejectedUserId!.map((x) => x)),
        "__v": v,
      };
}

class LandId {
  LandId({
    this.id,
    this.city,
    this.area,
    this.latitude,
    this.longitude,
    this.parcelId,
    this.wardNo,
    this.district,
    this.address,
    this.surveyNo,
    this.province,
    // this.landPrice,
    this.isVerified,
    this.ownerUserId,
    this.ownerHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.saleData,
  });

  String? id;
  String? city;
  String? area;
  String? parcelId;
  String? wardNo;
  String? district;
  String? address;
  String? surveyNo;
  String? province;
  // String? landPrice;
  String? isVerified;
  String? ownerUserId;
  List<dynamic>? ownerHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? latitude;
  String? longitude;
  String? saleData;

  factory LandId.fromJson(Map<String, dynamic> json) => LandId(
        id: json["_id"],
        city: json["city"],
        area: json["area"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        parcelId: json["parcelId"],
        wardNo: json["wardNo"],
        district: json["district"],
        address: json["address"],
        surveyNo: json["surveyNo"],
        province: json["province"],
        // landPrice: json["landPrice"],
        isVerified: json["isVerified"],
        ownerUserId: json["ownerUserId"],
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
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "city": city,
        "area": area,
        "latitude": latitude,
        "longitude": longitude,
        "parcelId": parcelId,
        "wardNo": wardNo,
        "district": district,
        "address": address,
        "surveyNo": surveyNo,
        "province": province,
        // "landPrice": landPrice,
        "isVerified": isVerified,
        "ownerUserId": ownerUserId,
        "ownerHistory": ownerHistory == null
            ? []
            : List<dynamic>.from(ownerHistory!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "saleData": saleData,
      };
}

class UserId {
  UserId({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNumber,
    this.isVerified,
    this.ownedLand,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.frontCitizenshipFile,
    this.imageFile,
    this.backCitizenshipFile,
    this.citizenshipId,
  });

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? phoneNumber;
  String? isVerified;
  List<String>? ownedLand;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  FrontCitizenshipFile? frontCitizenshipFile;
  ImageFile? imageFile;
  BackCitizenshipFile? backCitizenshipFile;
  int? citizenshipId;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        isVerified: json["isVerified"],
        citizenshipId: json["citizenshipId"],
        ownedLand: json["ownedLand"] == null
            ? []
            : List<String>.from(json["ownedLand"]!.map((x) => x)),
        name: json["name"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        frontCitizenshipFile: json["frontCitizenshipFile"] == null
            ? null
            : FrontCitizenshipFile.fromJson(json["frontCitizenshipFile"]),
        imageFile: json["imageFile"] == null
            ? null
            : ImageFile.fromJson(json["imageFile"]),
        backCitizenshipFile: json["backCitizenshipFile"] == null
            ? null
            : BackCitizenshipFile.fromJson(json["backCitizenshipFile"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "phoneNumber": phoneNumber,
        "isVerified": isVerified,
        "ownedLand": ownedLand == null
            ? []
            : List<dynamic>.from(ownedLand!.map((x) => x)),
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "frontCitizenshipFile": frontCitizenshipFile?.toJson(),
        "imageFile": imageFile?.toJson(),
        "backCitizenshipFile": backCitizenshipFile?.toJson(),
      };
}

class BackCitizenshipFile {
  BackCitizenshipFile({
    this.backCitizenshipImage,
    this.backCitizenshipPublicId,
  });

  String? backCitizenshipImage;
  String? backCitizenshipPublicId;

  factory BackCitizenshipFile.fromJson(Map<String, dynamic> json) =>
      BackCitizenshipFile(
        backCitizenshipImage: json["backCitizenshipImage"],
        backCitizenshipPublicId: json["backCitizenshipPublicId"],
      );

  Map<String, dynamic> toJson() => {
        "backCitizenshipImage": backCitizenshipImage,
        "backCitizenshipPublicId": backCitizenshipPublicId,
      };
}

class FrontCitizenshipFile {
  FrontCitizenshipFile({
    this.frontCitizenshipImage,
    this.frontCitizenshipPublicId,
  });

  String? frontCitizenshipImage;
  String? frontCitizenshipPublicId;

  factory FrontCitizenshipFile.fromJson(Map<String, dynamic> json) =>
      FrontCitizenshipFile(
        frontCitizenshipImage: json["frontCitizenshipImage"],
        frontCitizenshipPublicId: json["frontCitizenshipPublicId"],
      );

  Map<String, dynamic> toJson() => {
        "frontCitizenshipImage": frontCitizenshipImage,
        "frontCitizenshipPublicId": frontCitizenshipPublicId,
      };
}

class ImageFile {
  ImageFile({
    this.imageUrl,
    this.imagePublicId,
  });

  String? imageUrl;
  String? imagePublicId;

  factory ImageFile.fromJson(Map<String, dynamic> json) => ImageFile(
        imageUrl: json["imageUrl"],
        imagePublicId: json["imagePublicId"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "imagePublicId": imagePublicId,
      };
}

class UserDataResultsProperties {
  UserId? user;
  String? landPrice;
  String? id;

  UserDataResultsProperties({
    this.user,
    this.landPrice,
    this.id,
  });

  factory UserDataResultsProperties.fromJson(Map<String, dynamic> json) =>
      UserDataResultsProperties(
        user: json["user"] == null ? null : UserId.fromJson(json["user"]),
        landPrice: json["landPrice"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "landPrice": landPrice,
        "_id": id,
      };
}

class UserIdResultsProperties {
  String? user;
  String? landPrice;
  String? id;

  UserIdResultsProperties({
    this.user,
    this.landPrice,
    this.id,
  });

  factory UserIdResultsProperties.fromJson(Map<String, dynamic> json) =>
      UserIdResultsProperties(
        user: json["user"],
        landPrice: json["landPrice"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "landPrice": landPrice,
        "_id": id,
      };
}
