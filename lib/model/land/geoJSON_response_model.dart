import 'dart:convert';

import '../land_response_model.dart';

GeoJsonResponseModel geoJsonResponseModelFromJson(String str) =>
    GeoJsonResponseModel.fromJson(json.decode(str));

String geoJsonResponseModelToJson(GeoJsonResponseModel data) =>
    json.encode(data.toJson());

class GeoJsonResponseModel {
  GeoJsonResponseModel({
    this.data,
  });

  GeoJSONData? data;

  factory GeoJsonResponseModel.fromJson(Map<String, dynamic> json) =>
      GeoJsonResponseModel(
        data: json["data"] == null ? null : GeoJSONData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class GeoJSONData {
  GeoJSONData({
    this.geoJsonData,
  });

  GeoJson? geoJsonData;

  factory GeoJSONData.fromJson(Map<String, dynamic> json) => GeoJSONData(
        geoJsonData: json["geoJSONData"] == null
            ? null
            : GeoJson.fromJson(json["geoJSONData"]),
      );

  Map<String, dynamic> toJson() => {
        "geoJSONData": geoJsonData?.toJson(),
      };
}
