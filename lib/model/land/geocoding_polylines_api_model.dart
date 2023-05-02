// To parse this JSON data, do
//
//     final geocodingPolylinesApiResponseModel = geocodingPolylinesApiResponseModelFromJson(jsonString);

import 'dart:convert';

GeocodingPolylinesApiResponseModel geocodingPolylinesApiResponseModelFromJson(
        String str) =>
    GeocodingPolylinesApiResponseModel.fromJson(json.decode(str));

String geocodingPolylinesApiResponseModelToJson(
        GeocodingPolylinesApiResponseModel data) =>
    json.encode(data.toJson());

class GeocodingPolylinesApiResponseModel {
  String? type;
  List<Feature>? features;
  List<double>? bbox;
  Metadata? metadata;

  GeocodingPolylinesApiResponseModel({
    this.type,
    this.features,
    this.bbox,
    this.metadata,
  });

  factory GeocodingPolylinesApiResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GeocodingPolylinesApiResponseModel(
        type: json["type"],
        features: json["features"] == null
            ? []
            : List<Feature>.from(
                json["features"]!.map((x) => Feature.fromJson(x))),
        bbox: json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": features == null
            ? []
            : List<dynamic>.from(features!.map((x) => x.toJson())),
        "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
        "metadata": metadata?.toJson(),
      };
}

class Feature {
  List<double>? bbox;
  String? type;
  Properties? properties;
  Geometry? geometry;

  Feature({
    this.bbox,
    this.type,
    this.properties,
    this.geometry,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        bbox: json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
        type: json["type"],
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
        "type": type,
        "properties": properties?.toJson(),
        "geometry": geometry?.toJson(),
      };
}

class Geometry {
  List<List<double>>? coordinates;
  String? type;

  Geometry({
    this.coordinates,
    this.type,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null
            ? []
            : List<List<double>>.from(json["coordinates"]!
                .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(
                coordinates!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "type": type,
      };
}

class Properties {
  List<Segment>? segments;
  Summary? summary;
  List<int>? wayPoints;

  Properties({
    this.segments,
    this.summary,
    this.wayPoints,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        segments: json["segments"] == null
            ? []
            : List<Segment>.from(
                json["segments"]!.map((x) => Segment.fromJson(x))),
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        wayPoints: json["way_points"] == null
            ? []
            : List<int>.from(json["way_points"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "segments": segments == null
            ? []
            : List<dynamic>.from(segments!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
        "way_points": wayPoints == null
            ? []
            : List<dynamic>.from(wayPoints!.map((x) => x)),
      };
}

class Segment {
  double? distance;
  double? duration;
  List<Step>? steps;

  Segment({
    this.distance,
    this.duration,
    this.steps,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        distance: json["distance"],
        duration: json["duration"],
        steps: json["steps"] == null
            ? []
            : List<Step>.from(json["steps"]!.map((x) => Step.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "duration": duration,
        "steps": steps == null
            ? []
            : List<dynamic>.from(steps!.map((x) => x.toJson())),
      };
}

class Step {
  double? distance;
  double? duration;
  int? type;
  String? instruction;
  String? name;
  List<int>? wayPoints;

  Step({
    this.distance,
    this.duration,
    this.type,
    this.instruction,
    this.name,
    this.wayPoints,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        distance: json["distance"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        type: json["type"],
        instruction: json["instruction"],
        name: json["name"],
        wayPoints: json["way_points"] == null
            ? []
            : List<int>.from(json["way_points"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "duration": duration,
        "type": type,
        "instruction": instruction,
        "name": name,
        "way_points": wayPoints == null
            ? []
            : List<dynamic>.from(wayPoints!.map((x) => x)),
      };
}

class Summary {
  double? distance;
  double? duration;

  Summary({
    this.distance,
    this.duration,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        distance: json["distance"]?.toDouble(),
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "duration": duration,
      };
}

class Metadata {
  String? attribution;
  String? service;
  int? timestamp;
  Query? query;
  Engine? engine;

  Metadata({
    this.attribution,
    this.service,
    this.timestamp,
    this.query,
    this.engine,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        attribution: json["attribution"],
        service: json["service"],
        timestamp: json["timestamp"],
        query: json["query"] == null ? null : Query.fromJson(json["query"]),
        engine: json["engine"] == null ? null : Engine.fromJson(json["engine"]),
      );

  Map<String, dynamic> toJson() => {
        "attribution": attribution,
        "service": service,
        "timestamp": timestamp,
        "query": query?.toJson(),
        "engine": engine?.toJson(),
      };
}

class Engine {
  String? version;
  DateTime? buildDate;
  DateTime? graphDate;

  Engine({
    this.version,
    this.buildDate,
    this.graphDate,
  });

  factory Engine.fromJson(Map<String, dynamic> json) => Engine(
        version: json["version"],
        buildDate: json["build_date"] == null
            ? null
            : DateTime.parse(json["build_date"]),
        graphDate: json["graph_date"] == null
            ? null
            : DateTime.parse(json["graph_date"]),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "build_date": buildDate?.toIso8601String(),
        "graph_date": graphDate?.toIso8601String(),
      };
}

class Query {
  List<List<double>>? coordinates;
  String? profile;
  String? format;

  Query({
    this.coordinates,
    this.profile,
    this.format,
  });

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        coordinates: json["coordinates"] == null
            ? []
            : List<List<double>>.from(json["coordinates"]!
                .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        profile: json["profile"],
        format: json["format"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(
                coordinates!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "profile": profile,
        "format": format,
      };
}
