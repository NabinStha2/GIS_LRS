import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
  UserResponseModel({
    this.data,
  });

  UserModelData? data;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        data: json["data"] == null ? null : UserModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class UserModelData {
  UserModelData({
    this.userData,
  });

  UserData? userData;

  factory UserModelData.fromJson(Map<String, dynamic> json) => UserModelData(
        userData: json["userData"] == null ? null : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() => {
        "userData": userData?.toJson(),
      };
}

class UserData {
  UserData({
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
  });

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? phoneNumber;
  String? isVerified;
  List<dynamic>? ownedLand;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  FrontCitizenshipFile? frontCitizenshipFile;
  ImageFile? imageFile;
  BackCitizenshipFile? backCitizenshipFile;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["_id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        isVerified: json["isVerified"],
        ownedLand: json["ownedLand"] == null ? [] : List<dynamic>.from(json["ownedLand"]!.map((x) => x)),
        name: json["name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        frontCitizenshipFile: json["frontCitizenshipFile"] == null ? null : FrontCitizenshipFile.fromJson(json["frontCitizenshipFile"]),
        imageFile: json["imageFile"] == null ? null : ImageFile.fromJson(json["imageFile"]),
        backCitizenshipFile: json["backCitizenshipFile"] == null ? null : BackCitizenshipFile.fromJson(json["backCitizenshipFile"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "phoneNumber": phoneNumber,
        "isVerified": isVerified,
        "ownedLand": ownedLand == null ? [] : List<dynamic>.from(ownedLand!.map((x) => x)),
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

  factory BackCitizenshipFile.fromJson(Map<String, dynamic> json) => BackCitizenshipFile(
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

  factory FrontCitizenshipFile.fromJson(Map<String, dynamic> json) => FrontCitizenshipFile(
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
