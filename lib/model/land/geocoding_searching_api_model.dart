// To parse this JSON data, do
//
//     final geocodingSearchingApi = geocodingSearchingApiFromJson(jsonString);

import 'dart:convert';

List<GeocodingSearchingApiModel> geocodingSearchingApiModelFromJson(
        String str) =>
    List<GeocodingSearchingApiModel>.from(
        json.decode(str).map((x) => GeocodingSearchingApiModel.fromJson(x)));

String geocodingSearchingApiModelToJson(
        List<GeocodingSearchingApiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeocodingSearchingApiModel {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  List<String>? boundingbox;
  String? lat;
  String? lon;
  String? displayName;
  String? geocodingSearchingApiClass;
  String? type;
  double? importance;
  String? icon;

  GeocodingSearchingApiModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.boundingbox,
    this.lat,
    this.lon,
    this.displayName,
    this.geocodingSearchingApiClass,
    this.type,
    this.importance,
    this.icon,
  });

  factory GeocodingSearchingApiModel.fromJson(Map<String, dynamic> json) =>
      GeocodingSearchingApiModel(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        boundingbox: json["boundingbox"] == null
            ? []
            : List<String>.from(json["boundingbox"]!.map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        geocodingSearchingApiClass: json["class"],
        type: json["type"],
        importance: json["importance"]?.toDouble(),
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "boundingbox": boundingbox == null
            ? []
            : List<dynamic>.from(boundingbox!.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "class": geocodingSearchingApiClass,
        "type": type,
        "importance": importance,
        "icon": icon,
      };
}
