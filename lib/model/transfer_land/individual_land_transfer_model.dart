// To parse this JSON data, do
//
//     final landTransferResponseModel = landTransferResponseModelFromJson(jsonString);

import 'dart:convert';

import 'land_transfer_response_model.dart';

IndividualLandTransferResponseModel individualLandTransferResponseModelFromJson(
        String str) =>
    IndividualLandTransferResponseModel.fromJson(json.decode(str));

String individualLandTransferResponseModelToJson(
        IndividualLandTransferResponseModel data) =>
    json.encode(data.toJson());

class IndividualLandTransferResponseModel {
  LandTransferDataResult? data;

  IndividualLandTransferResponseModel({
    this.data,
  });

  factory IndividualLandTransferResponseModel.fromJson(
          Map<String, dynamic> json) =>
      IndividualLandTransferResponseModel(
        data: json["data"] == null
            ? null
            : LandTransferDataResult.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}
