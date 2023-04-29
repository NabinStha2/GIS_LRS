import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.data,
    this.message,
  });

  Data? data;
  String? message;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.token,
    this.userData,
  });

  String? token;
  UserData? userData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userData: json["userData"] == null ? null : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userData": userData?.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.address,
  });

  String? id;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? address;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["_id"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "phoneNumber": phoneNumber,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
      };
}
