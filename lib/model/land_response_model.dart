import 'dart:convert';

import 'land/individual_land_sale_response_model.dart';

LandResponseModel landResponseModelFromJson(String str) =>
    LandResponseModel.fromJson(json.decode(str));

String landResponseModelToJson(LandResponseModel data) =>
    json.encode(data.toJson());

class LandResponseModel {
  LandResponseModel({
    this.data,
  });

  LandResponseData? data;

  factory LandResponseModel.fromJson(Map<String, dynamic> json) =>
      LandResponseModel(
        data: json["data"] == null
            ? null
            : LandResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class LandResponseData {
  LandResponseData({
    this.landData,
  });

  LandData? landData;

  factory LandResponseData.fromJson(Map<String, dynamic> json) =>
      LandResponseData(
        landData: json["landData"] == null
            ? null
            : LandData.fromJson(json["landData"]),
      );

  Map<String, dynamic> toJson() => {
        "landData": landData?.toJson(),
      };
}

class LandData {
  LandData({
    this.count,
    this.totalPages,
    this.currentPageNumber,
    this.results,
  });

  int? count;
  int? totalPages;
  int? currentPageNumber;
  List<LandResult>? results;

  factory LandData.fromJson(Map<String, dynamic> json) => LandData(
        count: json["count"],
        totalPages: json["totalPages"],
        currentPageNumber: json["currentPageNumber"],
        results: json["results"] == null
            ? []
            : List<LandResult>.from(
                json["results"]!.map((x) => LandResult.fromJson(x))),
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

class LandResult {
  LandResult({
    this.id,
    this.city,
    this.area,
    this.parcelId,
    this.wardNo,
    this.district,
    this.address,
    this.surveyNo,
    this.province,
    this.landPrice,
    this.isVerified,
    this.ownerUserId,
    this.ownerHistory,
    this.saleData,
    this.geoJson,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.latitude,
    this.longitude,
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
  String? landPrice;
  String? isVerified;
  UserId? ownerUserId;
  List<String>? ownerHistory;
  String? saleData;
  GeoJson? geoJson;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? latitude;
  String? longitude;

  factory LandResult.fromJson(Map<String, dynamic> json) => LandResult(
        id: json["_id"],
        city: json["city"],
        area: json["area"],
        parcelId: json["parcelId"],
        wardNo: json["wardNo"],
        district: json["district"],
        address: json["address"],
        surveyNo: json["surveyNo"],
        province: json["province"],
        landPrice: json["landPrice"],
        isVerified: json["isVerified"],
        ownerUserId: json["ownerUserId"] == null
            ? null
            : UserId.fromJson(json["ownerUserId"]),
        ownerHistory: json["ownerHistory"] == null
            ? []
            : List<String>.from(json["ownerHistory"]!.map((x) => x)),
        saleData: json["saleData"],
        geoJson:
            json["geoJSON"] == null ? null : GeoJson.fromJson(json["geoJSON"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "city": city,
        "area": area,
        "parcelId": parcelId,
        "wardNo": wardNo,
        "district": district,
        "address": address,
        "surveyNo": surveyNo,
        "province": province,
        "landPrice": landPrice,
        "isVerified": isVerified,
        "ownerUserId": ownerUserId?.toJson(),
        "ownerHistory": ownerHistory == null
            ? []
            : List<dynamic>.from(ownerHistory!.map((x) => x)),
        "saleData": saleData,
        "geoJSON": geoJson?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class GeoJson {
  GeoJson({
    this.id,
    this.type,
    this.geometry,
    this.properties,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? type;
  Geometry? geometry;
  Properties? properties;
  int? v;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GeoJson.fromJson(Map<String, dynamic> json) => GeoJson(
        id: json["_id"],
        type: json["type"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
        v: json["__v"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "geometry": geometry?.toJson(),
        "properties": properties?.toJson(),
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String? type;
  List<List<List<double>>>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<List<List<double>>>.from(json["coordinates"]!.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

class Properties {
  Properties({
    this.fid,
    this.id,
    this.wardno,
    this.mapsheetno,
    this.sheetid,
    this.parcelno,
    this.area,
  });

  int? fid;
  String? id;
  String? wardno;
  String? mapsheetno;
  String? sheetid;
  String? parcelno;
  String? area;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        fid: json["FID"],
        id: json["id"],
        wardno: json["wardno"],
        mapsheetno: json["mapsheetno"],
        sheetid: json["sheetid"],
        parcelno: json["parcelno"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "FID": fid,
        "id": id,
        "wardno": wardno,
        "mapsheetno": mapsheetno,
        "sheetid": sheetid,
        "parcelno": parcelno,
        "area": area,
      };
}
