import 'dart:isolate';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gis_flutter_frontend/screens/land_sale_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:gis_flutter_frontend/core/app/colors.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:gis_flutter_frontend/main.dart';
import 'package:gis_flutter_frontend/providers/map_provider.dart';
import 'package:gis_flutter_frontend/widgets/custom_circular_progress_indicator.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';

import '../core/app/medias.dart';
import '../core/routing/route_navigation.dart';
import '../model/land/land_request_model.dart';
import '../providers/land_provider.dart';
import '../utils/scale_layer_plugin_options.dart';
import '../utils/zoom.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/drawer_widget.dart';
import 'dashboard_page.dart';

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

class MapPage extends StatefulWidget {
  final bool? isFromLand;
  final LatLng? latlngData;
  final String? geoJSONId;
  const MapPage({
    Key? key,
    this.isFromLand = false,
    this.latlngData,
    this.geoJSONId,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  double _radiusValue = 0.0;
  LatLng? selectedMarker;
  bool geocodingAddressSearching = false;
  bool geocodingAddressSearchingSwitch = true;
  bool direction = false;
  LatLng? endSelectedMarker;

  @override
  void initState() {
    consolelog("iam from init map");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (widget.isFromLand == true) {
      //   Provider.of<LandProvider>(context, listen: false).getGeoJSONDataById(
      //     context: context,
      //     geoJSONId: widget.geoJSONId ?? "",
      //   );
      // } else {
      // Provider.of<LandProvider>(context, listen: false).getOwnedLands(
      //     context: context,
      //     landRequestModel: LandRequestModel(page: 1, limit: 20),
      //     isFromMap: true,
      //     latlngData: widget.isFromLand ?? false ? widget.latlngData : null);

      Provider.of<LandProvider>(context, listen: false)
          .searchLandController
          .clear();
      selectedMarker = null;
      endSelectedMarker = null;

      Provider.of<LandProvider>(context, listen: false)
          .searchLandController
          .clear();
      Provider.of<LandProvider>(context, listen: false)
          .searchLandAddressController
          .clear();

      Provider.of<LandProvider>(context, listen: false).getSaleLand(
        context: context,
        landRequestModel: LandRequestModel(
          page: 1,
        ),
        isFromMap: true,
      );
      // }
    });
    super.initState();
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        return Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: GestureDetector(
            onTap: () {
              mapController.rotate((direction * (math.pi / 180) * -1));
            },
            child: Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image.asset(
                kCompassIcon,
                height: 40,
                width: 40,
              ),
            ),
          ),
        );
      },
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    consolelog("selectedMarker :: $selectedMarker");
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Map",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      drawerEnableOpenDragGesture: false,
      drawer: widget.isFromLand ?? false
          ? null
          : DrawerWidget(
              scKey: scKey,
            ),
      body: Consumer2<MapProvider, LandProvider>(
        builder: (context, _, __, child) {
          return __.isLoading && widget.isFromLand == false
              ? const CustomCircularProgressIndicatorWidget(
                  title: "Loading Map data...",
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                          onPointerHover: (PointerHoverEvent pointerHoverEvent,
                              LatLng location) {
                            // debugPrint("${pointerHoverEvent.toString()} :: $location");
                          },
                          // interactiveFlags: InteractiveFlag.drag |
                          //     InteractiveFlag.flingAnimation |
                          //     InteractiveFlag.pinchMove |
                          //     InteractiveFlag.pinchZoom |
                          //     InteractiveFlag.doubleTapZoom,
                          onTap: (tapPosition, LatLng location) {
                            consolelog(
                                "${tapPosition.global.distance.toString()} :: $location");

                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  content: GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text:
                                                  "${location.longitude},${location.latitude}"))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                          ..clearSnackBars()
                                          ..showSnackBar(const SnackBar(
                                            content: Text(
                                                "Location copied to clipboard"),
                                            backgroundColor: Colors.green,
                                          ));
                                      });
                                    },
                                    child: CustomText.ourText(
                                      location.toString(),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );

                            if (direction &&
                                selectedMarker != null &&
                                endSelectedMarker == null) {
                              setState(() {
                                endSelectedMarker = LatLng(
                                    location.latitude, location.longitude);
                              });
                              consolelog(
                                  "endSelectedMarker :: $endSelectedMarker");
                              __.geocodingPolylinesApi(
                                context: context,
                                startLocation:
                                    "${selectedMarker?.longitude},${selectedMarker?.latitude}",
                                endLocation:
                                    "${endSelectedMarker?.longitude},${endSelectedMarker?.latitude}",
                              );
                            } else {
                              setState(() {
                                polylines.clear();
                                endSelectedMarker = null;
                                selectedMarker = LatLng(
                                    location.latitude, location.longitude);
                              });
                            }
                          },
                          center: LatLng(currentPosition?.latitude ?? 0.0,
                              currentPosition?.longitude ?? 0.0),
                          zoom: 5,
                          maxZoom: 22,
                          enableScrollWheel: true,
                          scrollWheelVelocity: 0.008,
                          keepAlive: true,
                          minZoom: 0.0,
                          onMapReady: () {
                            widget.isFromLand == true &&
                                    widget.latlngData != null
                                ? [
                                    _animatedMapMove(widget.latlngData!, 20),
                                    setState(() {
                                      selectedMarker = LatLng(
                                          widget.latlngData!.latitude,
                                          widget.latlngData!.longitude);
                                    })
                                  ]
                                : null;
                          }),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(
                          source: 'OpenStreetMap contributors',
                          onSourceTapped: () {},
                        ),
                        ScaleLayerWidget(
                            options: ScaleLayerPluginOption(
                          lineColor: Colors.blue,
                          lineWidth: 2,
                          textStyle:
                              const TextStyle(color: Colors.blue, fontSize: 12),
                          padding: const EdgeInsets.all(10),
                        )),
                        const FlutterMapZoomButtons(
                          minZoom: 5,
                          maxZoom: 22,
                          mini: true,
                          padding: 10,
                          alignment: Alignment(-1, -0.85),
                          zoomInColorIcon: Colors.white,
                          zoomOutColorIcon: Colors.white,
                        ),
                      ],
                      children: [
                        IndexedStack(
                          index: _.tileLayerIndex,
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                              maxZoom: 18,
                              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                            ),
                            TileLayer(
                              urlTemplate:
                                  'http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',
                              maxZoom: 18,
                              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                            ),
                            // TileLayer(
                            //   urlTemplate:
                            //       'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                            //   maxZoom: 20,
                            //   subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                            // ),
                            TileLayer(
                              urlTemplate:
                                  'http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
                              maxZoom: 18,
                              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                            ),

                            TileLayer(
                              maxNativeZoom: 18,
                              maxZoom: 22,
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                              retinaMode: true &&
                                  MediaQuery.of(context).devicePixelRatio > 1.0,
                            ),
                            TileLayer(
                              maxNativeZoom: 18,
                              maxZoom: 22,
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibmFiaW5zdGhhMTIiLCJhIjoiY2xlazVqZGNjMGkyNTQzazU3dHpqd2thdiJ9.-DPZDLlSeIZg5uAl9hBOrA",
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                            ),
                            TileLayer(
                              maxNativeZoom: 18,
                              maxZoom: 22,
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibmFiaW5zdGhhMTIiLCJhIjoiY2xlazVqZGNjMGkyNTQzazU3dHpqd2thdiJ9.-DPZDLlSeIZg5uAl9hBOrA",
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                            ),
                            // TileLayer(
                            //   wmsOptions: WMSTileLayerOptions(
                            //     baseUrl: 'https://{s}.s2maps-tiles.eu/wms/?',
                            //     layers: ['s2cloudless-2021_3857'],
                            //   ),
                            //   subdomains: const [
                            //     'a',
                            //     'b',
                            //     'c',
                            //     'd',
                            //     'e',
                            //     'f',
                            //     'g',
                            //     'h'
                            //   ],
                            //   userAgentPackageName:
                            //       'dev.fleaflet.flutter_map.example',
                            // )
                          ],
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers:
                              // List.generate(latlngList.value.length,
                              //     (index) {
                              //   return Marker(
                              //       // width: 10,
                              //       // height: 10,
                              //       anchorPos: AnchorPos.align(AnchorAlign.center),
                              //       rotate: true,
                              //       point: latlngList.value[index].centerMarker ??
                              //           LatLng(0.0, 0.0),
                              //       builder: (context) {
                              //         return GestureDetector(
                              //           behavior: HitTestBehavior.opaque,
                              //           onTap: () {
                              //             consolelog("Data");
                              //             ScaffoldMessenger.of(context)
                              //                 .showSnackBar(const SnackBar(
                              //               content: Text(
                              //                   'Tapped on blue FlutterLogo Marker'),
                              //             ));
                              //             widget.isFromLand == false
                              //                 ? navigate(
                              //                     context,
                              //                     LandDetailsScreen(
                              //                       landId: latlngList
                              //                           .value[index].landId,
                              //                     ))
                              //                 : null;
                              //           },
                              //           child: Image.asset(kMarkerIcon),
                              //         );
                              //       });
                              // })
                              //   ..addAll(
                              [
                            Marker(
                                anchorPos: AnchorPos.align(AnchorAlign.center),
                                width: 15,
                                height: 15,
                                point: LatLng(currentPosition?.latitude ?? 0.0,
                                    currentPosition?.longitude ?? 0.0),
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  );
                                }),
                            Marker(
                                anchorPos: AnchorPos.align(AnchorAlign.center),
                                point: selectedMarker ?? LatLng(0.0, 0.0),
                                builder: (BuildContext context) {
                                  return Image.asset(kMarkerIcon,
                                      color: direction ? Colors.green : null);
                                }),
                            Marker(
                                anchorPos: AnchorPos.align(AnchorAlign.center),
                                point: endSelectedMarker ?? LatLng(0.0, 0.0),
                                builder: (BuildContext context) {
                                  return Image.asset(kMarkerIcon);
                                }),
                          ],
                        ),
                        // ),
                        PolygonLayer(
                          polygonCulling: true,
                          polygons: List.generate(
                            latlngList.value.length,
                            (index) => Polygon(
                              points: latlngList.value[index].polygonData ?? [],
                              isFilled: false,
                              borderColor: Colors.red,
                              borderStrokeWidth: 1,
                              label: latlngList.value[index].parcelId,
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.outfit().fontFamily,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              labelPlacement: PolygonLabelPlacement.centroid,
                            ),
                          ),
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polylines,
                              strokeWidth: 6,
                              color: AppColors.kPrimaryColor,
                              isDotted: true,
                              useStrokeWidthInMeter: true,
                              borderStrokeWidth: 1,
                            ),
                          ],
                          polylineCulling: true,
                        ),
                        // LatLonGridLayer(
                        //   options: LatLonGridLayerOptions(
                        //     lineWidth: 0.5,
                        //     lineColor: const Color.fromARGB(100, 0, 0, 0),
                        //     labelStyle: const TextStyle(
                        //       color: Colors.white,
                        //       backgroundColor: Colors.black,
                        //       fontSize: 12.0,
                        //     ),
                        //     showCardinalDirections: true,
                        //     showCardinalDirectionsAsPrefix: true,
                        //     showLabels: true,
                        //     rotateLonLabels: true,
                        //     placeLabelsOnLines: true,
                        //     offsetLonLabelsBottom: 20.0,
                        //     offsetLatLabelsLeft: 20.0,
                        //   ),
                        // ),
                      ],
                    ),
                    Positioned(
                      top: -1,
                      child: SizedBox(
                        height: 50,
                        width: appWidth(context),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                hintText: geocodingAddressSearchingSwitch
                                    ? "Search location by address"
                                    : "Search location by coordinates...",
                                filled: true,
                                borderRadius: 8,
                                controller: geocodingAddressSearchingSwitch
                                    ? __.searchLandAddressController
                                    : __.searchLandController,
                                suffix: const Icon(Icons.search),
                                isFromSearch: true,
                                textInputType: TextInputType.text,
                                onFieldSubmitted: (val) {
                                  consolelog("map search :: $val");
                                  if (val != "") {
                                    if (!geocodingAddressSearchingSwitch) {
//   LatLngModel latlngSearchData = latlngList.value
                                      //       .firstWhere(
                                      //           (element) =>
                                      //               element.parcelId ==
                                      //               __.searchLandController.text,
                                      //           orElse: () => LatLngModel());

                                      //   if (latlngSearchData.parcelId == val) {
                                      //     mapController.move(
                                      //         latlngSearchData.centerMarker ?? LatLng(0, 0),
                                      //         20);
                                      //   } else {
                                      //     errorToast(msg: "No parcel Id found");
                                      //  }

                                      __.getSaleLand(
                                        context: context,
                                        landRequestModel: LandRequestModel(
                                          page: 1,
                                          latlng: val,
                                          radius: _radiusValue,
                                        ),
                                        noLoading: true,
                                        isFromMap: true,
                                      );
                                      setState(() {
                                        selectedMarker = LatLng(
                                            double.parse(val.split(",")[1]),
                                            double.parse(val.split(",")[0]));
                                      });
                                      _animatedMapMove(
                                          LatLng(
                                              double.parse(val.split(",")[1]),
                                              double.parse(val.split(",")[0])),
                                          17);
                                    } else {
                                      setState(() {
                                        geocodingAddressSearching = true;
                                      });

                                      __.geocodingSearchingApi(
                                        context: context,
                                        searchLocation: val.toString().trim(),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      geocodingAddressSearching = false;
                                    });
                                    __.getSaleLand(
                                      context: context,
                                      landRequestModel: LandRequestModel(
                                        page: 1,
                                      ),
                                      isFromMap: true,
                                      noLoading: true,
                                    );
                                  }
                                },
                              ),
                            ),
                            hSizedBox1,
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    elevation: 0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (_) {
                                      return StatefulBuilder(
                                        builder: (context, innerSetState) =>
                                            Container(
                                          padding: screenLeftRightPadding,
                                          height: 300,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText.ourText(
                                                    "Search by Address",
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  Switch(
                                                    // activeColor: Colors.amber,
                                                    activeTrackColor:
                                                        Colors.cyan,
                                                    inactiveThumbColor: Colors
                                                        .blueGrey.shade600,
                                                    inactiveTrackColor:
                                                        Colors.grey.shade400,
                                                    splashRadius: 50.0,
                                                    value:
                                                        geocodingAddressSearchingSwitch,
                                                    onChanged: (value) {
                                                      consolelog(
                                                          "Switch value :: $value");
                                                      innerSetState(() =>
                                                          geocodingAddressSearchingSwitch =
                                                              value);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText.ourText(
                                                    "Direction",
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  Switch(
                                                    activeTrackColor:
                                                        Colors.cyan,
                                                    inactiveThumbColor: Colors
                                                        .blueGrey.shade600,
                                                    inactiveTrackColor:
                                                        Colors.grey.shade400,
                                                    splashRadius: 50.0,
                                                    value: direction,
                                                    onChanged: (value) {
                                                      consolelog(
                                                          "Switch value direction :: $value");
                                                      innerSetState(() =>
                                                          direction = value);
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                              vSizedBox1,
                                              CustomText.ourText(
                                                "Set radius to search within",
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              vSizedBox0,
                                              Slider(
                                                inactiveColor:
                                                    Colors.grey.shade100,
                                                value: _radiusValue,
                                                min: 0.0,
                                                max: 10000.0,
                                                divisions: 100,
                                                label: _radiusValue
                                                    .toStringAsFixed(2),
                                                onChanged: (double newValue) {
                                                  innerSetState(() {
                                                    _radiusValue = newValue;
                                                  });
                                                },
                                              ),
                                              vSizedBox1,
                                              CustomButton.elevatedButton(
                                                "Save",
                                                () {
                                                  consolelog(
                                                      "${__.searchLandAddressController.text} :: ${!geocodingAddressSearchingSwitch}");
                                                  if (!geocodingAddressSearchingSwitch &&
                                                      (__.searchLandController
                                                              .text.isNotEmpty ||
                                                          __.searchLandAddressController
                                                              .text.isNotEmpty)) {
                                                    __.getSaleLand(
                                                      context: context,
                                                      landRequestModel:
                                                          LandRequestModel(
                                                        page: 1,
                                                        latlng: __
                                                            .searchLandController
                                                            .text,
                                                        radius: _radiusValue,
                                                      ),
                                                      noLoading: true,
                                                      isFromMap: true,
                                                    );
                                                    back(context);
                                                    setState(() {
                                                      selectedMarker = LatLng(
                                                          double.parse(__
                                                              .searchLandController
                                                              .text
                                                              .split(",")[1]),
                                                          double.parse(__
                                                              .searchLandController
                                                              .text
                                                              .split(",")[0]));
                                                    });
                                                    _animatedMapMove(
                                                        LatLng(
                                                            double.parse(__
                                                                .searchLandController
                                                                .text
                                                                .split(",")[1]),
                                                            double.parse(__
                                                                .searchLandController
                                                                .text
                                                                .split(
                                                                    ",")[0])),
                                                        17);
                                                  } else {
                                                    back(context);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: const Icon(Icons.filter_alt)),
                            ),
                            hSizedBox1,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      right: 20,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _.tileLayerIndex >= 0 && _.tileLayerIndex < 5
                                  ? _.changeTileLayerIndex(_.tileLayerIndex + 1)
                                  : _.tileLayerIndex == 5
                                      ? _.changeTileLayerIndex(0)
                                      : null;
                            },
                            icon: const Icon(
                              Icons.change_circle,
                              size: 32,
                            ),
                          ),
                          hSizedBox0,
                          IconButton(
                            onPressed: () {
                              _animatedMapMove(
                                  LatLng(currentPosition?.latitude ?? 0.0,
                                      currentPosition?.longitude ?? 0.0),
                                  18);
                            },
                            icon: const Icon(
                              Icons.location_searching,
                              size: 32,
                            ),
                          ),
                          _buildCompass(),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 28,
                      child: Container(
                        constraints:
                            BoxConstraints(maxHeight: 190, maxWidth: kWidth),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _animatedMapMove(
                                    latlngList.value[index].centerMarker ??
                                        LatLng(0.0, 0.0),
                                    20);
                                if (direction &&
                                    selectedMarker != null &&
                                    endSelectedMarker == null) {
                                  setState(() {
                                    endSelectedMarker = LatLng(
                                        latlngList.value[index].centerMarker
                                                ?.latitude ??
                                            0.0,
                                        latlngList.value[index].centerMarker
                                                ?.longitude ??
                                            0.0);
                                  });
                                  __.geocodingPolylinesApi(
                                    context: context,
                                    startLocation:
                                        "${selectedMarker?.longitude},${selectedMarker?.latitude}",
                                    endLocation:
                                        "${endSelectedMarker?.longitude},${endSelectedMarker?.latitude}",
                                  );
                                } else {
                                  setState(() {
                                    polylines.clear();
                                    endSelectedMarker = null;
                                    selectedMarker = LatLng(
                                        latlngList.value[index].centerMarker
                                                ?.latitude ??
                                            0.0,
                                        latlngList.value[index].centerMarker
                                                ?.longitude ??
                                            0.0);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                constraints: BoxConstraints(
                                  maxHeight: 120,
                                  maxWidth: appWidth(context) * 0.6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.kPrimaryColor2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomText.ourText(
                                                  "Parcel Id:",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText.ourText(
                                                  latlngList
                                                      .value[index].parcelId,
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          vSizedBox0,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomText.ourText(
                                                  "Name:",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText.ourText(
                                                  latlngList.value[index].name,
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          vSizedBox0,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomText.ourText(
                                                  "Address:",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText.ourText(
                                                  latlngList
                                                      .value[index].address,
                                                  maxLines: 1,
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          vSizedBox0,
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CustomText.ourText(
                                                  "Area:",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText.ourText(
                                                  latlngList.value[index].area,
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomButton.textButton(
                                      "View Details",
                                      () {
                                        navigate(
                                            context,
                                            LandSaleDetailsScreen(
                                              landSaleId: latlngList
                                                  .value[index].landSaleId,
                                            ));
                                      },
                                      fontSize: 12.0,
                                      isFitted: true,
                                      height: 35,
                                      titleColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => hSizedBox2,
                          itemCount: latlngList.value.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                    geocodingAddressSearching
                        ? Positioned(
                            top: 49,
                            child: Container(
                              padding: screenLeftRightPadding,
                              color: Colors.white,
                              constraints: BoxConstraints(
                                maxWidth: appWidth(context),
                                minHeight: 470,
                                maxHeight: 470,
                              ),
                              child: __.isGeocodingSearchingApiLoading
                                  ? const Center(
                                      child:
                                          CustomCircularProgressIndicatorWidget(),
                                    )
                                  : __.geocodingSearchingApiData?.isEmpty ??
                                          false
                                      ? Center(
                                          child: CustomText.ourText(
                                            "No search results found.",
                                            fontSize: 16.0,
                                          ),
                                        )
                                      : ListView.separated(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                __.getSaleLand(
                                                  context: context,
                                                  landRequestModel:
                                                      LandRequestModel(
                                                    page: 1,
                                                    latlng:
                                                        "${__.geocodingSearchingApiData?[index].lon},${__.geocodingSearchingApiData?[index].lat}",
                                                    radius: _radiusValue,
                                                  ),
                                                  noLoading: true,
                                                  isFromMap: true,
                                                );
                                                setState(() {
                                                  geocodingAddressSearching =
                                                      false;
                                                  selectedMarker = LatLng(
                                                      double.parse(__
                                                              .geocodingSearchingApiData?[
                                                                  index]
                                                              .lat ??
                                                          ""),
                                                      double.parse(__
                                                              .geocodingSearchingApiData?[
                                                                  index]
                                                              .lon ??
                                                          ""));
                                                });

                                                _animatedMapMove(
                                                    LatLng(
                                                        double.parse(__
                                                                .geocodingSearchingApiData?[
                                                                    index]
                                                                .lat ??
                                                            ""),
                                                        double.parse(__
                                                                .geocodingSearchingApiData?[
                                                                    index]
                                                                .lon ??
                                                            "")),
                                                    17);
                                              },
                                              child: Container(
                                                padding: screenPadding,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        AppColors.kBorderColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: CustomText.ourText(
                                                  __
                                                      .geocodingSearchingApiData?[
                                                          index]
                                                      .displayName,
                                                  fontSize: 14.0,
                                                  maxLines: 4,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              vSizedBox1,
                                          itemCount: __
                                                  .geocodingSearchingApiData
                                                  ?.length ??
                                              0,
                                        ),
                            ),
                          )
                        : Container(),
                  ],
                );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
