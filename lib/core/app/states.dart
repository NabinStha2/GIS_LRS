import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../model/land/land_request_model.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final List<LatLng> polylines = <LatLng>[];

class RequiredArgs {
  final SendPort sendPort;
  final LandRequestModel? id;

  RequiredArgs(
    this.sendPort,
    this.id,
  );
}

class LatLngModel {
  String? landSaleId;
  String? landId;
  String? parcelId;
  List<LatLng>? polygonData;
  LatLng? centerMarker;
  String? address;
  String? area;
  String? wardNo;
  String? landPrice;
  String? mapSheetNo;
  String? street;
  String? name;
  String? ownerUserId;
  String? email;
  LatLngModel({
    this.landId,
    this.parcelId,
    this.polygonData,
    this.centerMarker,
    this.address,
    this.area,
    this.wardNo,
    this.landPrice,
    this.name,
    this.ownerUserId,
    this.email,
    this.landSaleId,
    this.mapSheetNo,
    this.street,
  });
}

ValueNotifier<List<LatLngModel>> latlngList = ValueNotifier<List<LatLngModel>>([
  // {
  //   "polygonData": [
  //     LatLng(28.2561422405137, 83.9799461371451),
  //     LatLng(28.2549, 83.9762),
  //     LatLng(28.2553, 83.9766),
  //     LatLng(28.2554, 83.9764),
  //   ],
  //   "parcelId": "10",
  // }
]);

TextEditingController searchController = TextEditingController();
MapController mapController = MapController();
