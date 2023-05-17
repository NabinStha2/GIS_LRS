// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';

import '../core/app/colors.dart';
import '../core/routing/route_navigation.dart';
import '../model/land/land_request_model.dart';
import '../utils/custom_toasts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_network_image_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import 'map_page.dart';

class LandDetailsScreen extends StatefulWidget {
  final String? landId;
  const LandDetailsScreen({
    Key? key,
    this.landId,
  }) : super(key: key);

  @override
  State<LandDetailsScreen> createState() => _LandDetailsScreenState();
}

class _LandDetailsScreenState extends State<LandDetailsScreen> {
  double? lat;
  double? long;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getIndividualLand(
          context: context,
          landRequestModel: LandRequestModel(
            landId: widget.landId,
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Consumer<LandProvider>(
        builder: (context, _, child) {
          var latlngTempList = <LatLng>[];
          _.individualLandResult?.geoJson?.geometry?.coordinates
              ?.forEach((element) {
            // long = element[0][0];
            // lat = element[0][1];

            for (var ele2 in element) {
              latlngTempList.add(LatLng(ele2[1], ele2[0]));
            }
          });
          if (latlngTempList.isNotEmpty) {
            lat = LatLngBounds.fromPoints(latlngTempList).center.latitude;
            long = LatLngBounds.fromPoints(latlngTempList).center.longitude;
          }

          // consolelog("$lat :: $long");

          return _.isLoading
              ? const CustomCircularProgressIndicatorWidget(
                  title: "Loading individual land...",
                )
              : _.getIndividualLandMessage != null
                  ? Center(
                      child: CustomText.ourText(_.getIndividualLandMessage,
                          color: Colors.red),
                    )
                  : SingleChildScrollView(
                      padding: screenLeftRightPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.ourText(
                            "Land Information",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kBrandPrimaryColor,
                          ),
                          vSizedBox1,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: const CustomNetworkImage(
                                      imageUrl:
                                          "https://img.freepik.com/free-vector/image-upload-concept-illustration_23-2148276163.jpg?size=338&ext=jpg",
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                  vSizedBox2,
                                  CustomButton.elevatedButton(
                                    "See on map",
                                    () {
                                      _.individualLandResult?.geoJson?.geometry
                                                  ?.coordinates?.isNotEmpty ??
                                              false
                                          ? navigate(
                                              context,
                                              MapPage(
                                                isFromLand: true,
                                                geoJSONId: _
                                                    .individualLandResult
                                                    ?.geoJson
                                                    ?.id,
                                                latlngData: LatLng(
                                                  lat ?? 0.0,
                                                  long ?? 0.0,
                                                ),
                                                parcelId: _.individualLandResult
                                                    ?.parcelId,
                                                // lat
                                                // latlngData: LatLng(
                                                //     double.parse(_
                                                //             .individualLandResult
                                                //             ?.polygon?[0]
                                                //             .latitude ??
                                                //         "0"),
                                                //     double.parse(_
                                                //             .individualLandResult
                                                //             ?.polygon?[0]
                                                //             .longitude ??
                                                //         "0")),
                                              ),
                                            )
                                          : errorToast(
                                              msg: "Coordinates not available");
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
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _.individualLandResult?.id ??
                                                "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
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
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _.individualLandResult
                                                    ?.parcelId ??
                                                "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    vSizedBox1,
                                    // Text.rich(
                                    //   TextSpan(
                                    //     text: "Price: NPR. ",
                                    //     style:  TextStyle(
                                    //       color: AppColors.kNeutral800Color,
                                    //       fontSize: 14.0,
                                    //       fontWeight: FontWeight.w600,
                                    //     ),
                                    //     children: [
                                    //       TextSpan(
                                    //         text: _.individualLandResult
                                    //                 ?.landPrice ??
                                    //             "",
                                    //         style: TextStyle(
                                    //           color: AppColors.kNeutral600Color,
                                    //           fontWeight: FontWeight.w400,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // vSizedBox1,
                                    Text.rich(
                                      TextSpan(
                                        text: "status: ",
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _.individualLandResult
                                                    ?.isVerified ??
                                                "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          vSizedBox2,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: "City: ",
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                _.individualLandResult?.city ??
                                                    "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    vSizedBox1,
                                    Text.rich(
                                      TextSpan(
                                        text: "District: ",
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _.individualLandResult
                                                    ?.district ??
                                                "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: "Area: ",
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                _.individualLandResult?.area ??
                                                    "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    vSizedBox1,
                                    Text.rich(
                                      TextSpan(
                                        text: "Province: ",
                                        style: TextStyle(
                                          color: AppColors.kNeutral800Color,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _.individualLandResult
                                                    ?.province ??
                                                "",
                                            style: TextStyle(
                                              color: AppColors.kNeutral600Color,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    vSizedBox1,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          vSizedBox2,
                          CustomText.ourText(
                            "Address (Survey No.)",
                            color: AppColors.kNeutral800Color,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          vSizedBox0,
                          CustomText.ourText(
                            "${_.individualLandResult?.address} (${_.individualLandResult?.surveyNo})",
                            color: AppColors.kNeutral600Color,
                            fontWeight: FontWeight.w400,
                          ),
                          vSizedBox2,
                          Text.rich(
                            TextSpan(
                              text: "Ward No: ",
                              style: TextStyle(
                                color: AppColors.kNeutral800Color,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: _.individualLandResult?.wardNo ?? "",
                                  style: TextStyle(
                                    color: AppColors.kNeutral600Color,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          vSizedBox2,
                          Text.rich(
                            TextSpan(
                              text: "Created At: ",
                              style: TextStyle(
                                color: AppColors.kNeutral800Color,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: DateFormat('d MMM, yyyy h:mm a').format(
                                      _.individualLandResult!.createdAt ??
                                          DateTime(2023)),
                                  style: TextStyle(
                                    color: AppColors.kNeutral600Color,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          vSizedBox2,
                          CustomText.ourText(
                            "User Information",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kBrandPrimaryColor,
                          ),
                          vSizedBox1,
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.kSecondaryBorderColor,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _.individualLandResult?.ownerUserId?.imageFile
                                            ?.imageUrl !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CustomNetworkImage(
                                          imageUrl: _
                                              .individualLandResult
                                              ?.ownerUserId
                                              ?.imageFile
                                              ?.imageUrl,
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Icon(Icons.person),
                                      ),
                                hSizedBox2,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CustomText.ourText(
                                              _.individualLandResult
                                                      ?.ownerUserId?.name ??
                                                  "",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          _.individualLandResult?.ownerUserId
                                                      ?.id ==
                                                  AppSharedPreferences.getUserId
                                              ? const Icon(
                                                  Icons.verified_user,
                                                  color: Colors.green,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      vSizedBox2,
                                      CustomText.ourText(
                                        _.individualLandResult?.ownerUserId
                                                ?.email ??
                                            "",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      vSizedBox2,
                                      CustomText.ourText(
                                        _.individualLandResult?.ownerUserId
                                                ?.phoneNumber ??
                                            "",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      vSizedBox2,
                                      CustomText.ourText(
                                        _.individualLandResult?.ownerUserId
                                                ?.address ??
                                            "",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      vSizedBox2,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          vSizedBox2,
                          CustomTextFormField(
                            borderRadius: 12,
                            onlyNumber: true,
                            hintText: "Enter the price for land sale...",
                            labelText: "Price",
                            textInputType: TextInputType.number,
                            controller: _.landPriceSaleController,
                            validator: (val) {
                              return val.toString().isEmpty
                                  ? "Empty field"
                                  : null;
                            },
                          ),
                          vSizedBox2,
                          AppSharedPreferences.getUserId ==
                                      _.individualLandResult?.ownerUserId?.id &&
                                  _.individualLandResult?.isVerified ==
                                      "approved" &&
                                  _.individualLandResult?.saleData == "null"
                              ? CustomButton.elevatedButton(
                                  "Add Land For Sale",
                                  () {
                                    if (_.landPriceSaleController.text
                                        .isNotEmpty) {
                                      Provider.of<LandProvider>(context,
                                              listen: false)
                                          .addSaleLand(
                                              context: context,
                                              landRequestModel:
                                                  LandRequestModel(
                                                landId:
                                                    _.individualLandResult?.id,
                                              ));
                                    } else {
                                      errorToast(msg: "Please give the price");
                                    }
                                  },
                                )
                              : AppSharedPreferences.getUserId ==
                                          _.individualLandResult?.ownerUserId
                                              ?.id &&
                                      _.individualLandResult?.saleData ==
                                          "selling"
                                  ? CustomText.ourText(
                                      "Land is already on sale",
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : Container(),
                          vSizedBox2,
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
