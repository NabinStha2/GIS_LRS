// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:latlong2/latlong.dart';

import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/screens/map_page.dart';
import 'package:gis_flutter_frontend/utils/custom_toasts.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../model/land/individual_land_sale_response_model.dart';
import '../model/land_response_model.dart';
import '../screens/land_details_screen.dart';
import '../screens/land_sale_details_screen.dart';
import 'custom_button.dart';
import 'custom_network_image_widget.dart';

class LandCardWidget extends StatelessWidget {
  LandResult? landResult;
  LandId? landData;
  final bool? isFromLandSale;
  final String? saleData;
  final String? landSaleId;
  final String? landId;
  final GeoJson? geoJSONLandSaleData;
  LandCardWidget({
    Key? key,
    this.landResult,
    this.landData,
    this.isFromLandSale = false,
    this.saleData,
    this.landSaleId,
    this.landId,
    this.geoJSONLandSaleData,
  }) : super(key: key);

  double? lat;
  double? long;

  @override
  Widget build(BuildContext context) {
    if (isFromLandSale == true) {
      geoJSONLandSaleData?.geometry?.coordinates?.forEach((element) {
        long = element[0][0];
        lat = element[0][1];
      });
    } else {
      landResult?.geoJson?.geometry?.coordinates?.forEach((val1) {
        consolelog(val1[0]);
        long = val1[0][0];
        lat = val1[0][1];
        // for (var element in val1) {
        //   consolelog(element);
        // }
      });
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.kContainerShadeColor,
        border: Border.all(color: AppColors.kBorderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const CustomNetworkImage(
                imageUrl:
                    "https://img.freepik.com/free-vector/image-upload-concept-illustration_23-2148276163.jpg?size=338&ext=jpg",
              ),
              vSizedBox2,
              CustomButton.elevatedButton(
                "See on map",
                () {
                  isFromLandSale ?? false
                      ? geoJSONLandSaleData
                                  ?.geometry?.coordinates?.isNotEmpty ??
                              false
                          ? navigate(
                              context,
                              MapPage(
                                isFromLand: true,
                                geoJSONId: geoJSONLandSaleData?.id,
                                latlngData: LatLng(
                                  lat ?? 0.0,
                                  long ?? 0.0,
                                ),
                                // latlngData: LatLng(
                                //     double.parse(
                                //         landData?.polygon?[0].latitude ?? "0"),
                                //     double.parse(
                                //         landData?.polygon?[0].longitude ??
                                //             "0")),
                              ),
                            )
                          : errorToast(msg: "Coordinates not available")
                      : landResult?.geoJson?.geometry?.coordinates
                                  ?.isNotEmpty ??
                              false
                          ? navigate(
                              context,
                              MapPage(
                                isFromLand: true,
                                geoJSONId: landResult?.geoJson?.id,
                                latlngData: LatLng(
                                  lat ?? 0.0,
                                  long ?? 0.0,
                                ),

                                // latlngData: LatLng(
                                //     double.parse(
                                //         landResult?.polygon?[0].latitude ??
                                //             "0"),
                                //     double.parse(
                                //         landResult?.polygon?[0].longitude ??
                                //             "0")),
                              ),
                            )
                          : errorToast(msg: "Coordinates not available");
                },
              ),
            ],
          ),
          hSizedBox2,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Id: ",
                    style: const TextStyle(
                      color: AppColors.kTextPrimaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: isFromLandSale ?? false
                            ? landData?.id
                            : landResult?.id,
                        style: TextStyle(
                          color: AppColors.kHeadingColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                vSizedBox1,
                Text.rich(
                  TextSpan(
                    text: "Parcel Id: ",
                    style: const TextStyle(
                      color: AppColors.kTextPrimaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: isFromLandSale ?? false
                            ? landData?.parcelId
                            : landResult?.parcelId,
                        style: TextStyle(
                          color: AppColors.kHeadingColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                vSizedBox1,
                // vSizedBox1,
                // CustomText.ourText(
                //     "Area: ${landResult?.area}"),
                // vSizedBox1,
                // CustomText.ourText(
                //     "Location: ${landResult?.address}, ${landResult?.city}"),
                // vSizedBox1,
                Text.rich(
                  TextSpan(
                    text: "Price: NPR. ",
                    style: const TextStyle(
                      color: AppColors.kTextPrimaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: isFromLandSale ?? false
                            ? landData?.landPrice
                            : landResult?.landPrice,
                        style: TextStyle(
                          color: AppColors.kHeadingColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                vSizedBox1,
                Text.rich(
                  TextSpan(
                    text: "status: ",
                    style: const TextStyle(
                      color: AppColors.kTextPrimaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: isFromLandSale ?? false
                            ? saleData
                            : landResult?.isVerified,
                        style: TextStyle(
                          color: AppColors.kHeadingColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                vSizedBox1,
                CustomButton.elevatedButton(
                  "View Details",
                  () {
                    isFromLandSale ?? false
                        ? navigate(
                            context,
                            LandSaleDetailsScreen(
                              landSaleId: landSaleId,
                            ))
                        : navigate(
                            context,
                            LandDetailsScreen(
                              landId: landId,
                            ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
