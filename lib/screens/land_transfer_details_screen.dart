// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gis_flutter_frontend/model/transfer_land/land_transfer_request_model.dart';
import 'package:gis_flutter_frontend/screens/payment_form.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';

import '../core/app/colors.dart';
import '../core/routing/route_navigation.dart';
import '../providers/land_transfer_provider.dart';
import '../utils/custom_toasts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_network_image_widget.dart';
import '../widgets/custom_text.dart';
import 'map_page.dart';

class LandTransferDetailsScreen extends StatefulWidget {
  final String? landTransferId;
  const LandTransferDetailsScreen({
    Key? key,
    this.landTransferId,
  }) : super(key: key);

  @override
  State<LandTransferDetailsScreen> createState() =>
      _LandSaleDetailsScreenState();
}

class _LandSaleDetailsScreenState extends State<LandTransferDetailsScreen> {
  double? lat;
  double? long;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandTransferProvider>(context, listen: false)
          .getIndividualLandTransfer(
              context: context,
              landTransferRequestModel: LandTransferRequestModel(
                landTransferId: widget.landTransferId,
              ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land Transfer Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Consumer<LandTransferProvider>(builder: (context, _, child) {
        var latlngTempList = <LatLng>[];
        _.individualLandTransferResult?.landSaleId?.geoJson?.geometry
            ?.coordinates
            ?.forEach((element) {
          for (var ele2 in element) {
            latlngTempList.add(LatLng(ele2[1], ele2[0]));
          }
        });
        if (latlngTempList.isNotEmpty) {
          lat = LatLngBounds.fromPoints(latlngTempList).center.latitude;
          long = LatLngBounds.fromPoints(latlngTempList).center.longitude;
        }
        return _.isLoading
            ? const CustomCircularProgressIndicatorWidget(
                title: "Loading individual land transfer...",
              )
            : _.getIndividualLandTransferMsg != null
                ? Center(
                    child: CustomText.ourText(_.getIndividualLandTransferMsg,
                        color: Colors.red),
                  )
                : _.individualLandTransferResult?.id != null
                    ? SingleChildScrollView(
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
                                        _
                                                    .individualLandTransferResult
                                                    ?.landSaleId
                                                    ?.geoJson
                                                    ?.geometry
                                                    ?.coordinates
                                                    ?.isNotEmpty ??
                                                false
                                            ? navigate(
                                                context,
                                                MapPage(
                                                  isFromLand: true,
                                                  geoJSONId: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.geoJson
                                                      ?.id,
                                                  latlngData: LatLng(
                                                    lat ?? 0.0,
                                                    long ?? 0.0,
                                                  ),
                                                  parcelId: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.parcelId,
                                                  // latlngData: LatLng(
                                                  //     double.parse(_
                                                  //             .individualLandTransferResult?.landSaleId
                                                  //             ?.landId
                                                  //             ?.polygon?[0]
                                                  //             .latitude ??
                                                  //         "0"),
                                                  //     double.parse(_
                                                  //             .individualLandTransferResult?.landSaleId
                                                  //             ?.landId
                                                  //             ?.polygon?[0]
                                                  //             .longitude ??
                                                  //         "0")),
                                                ),
                                              )
                                            : errorToast(
                                                msg:
                                                    "Coordinates not available");
                                      },
                                    ),
                                  ],
                                ),
                                hSizedBox2,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              text: _.individualLandTransferResult
                                                      ?.landSaleId?.landId?.id ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                              text: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.landId
                                                      ?.parcelId ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      vSizedBox1,
                                      Text.rich(
                                        TextSpan(
                                          text: "Price: NPR. ",
                                          style: TextStyle(
                                            color: AppColors.kNeutral800Color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _.individualLandTransferResult
                                                      ?.landSaleId?.landPrice ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                          style: TextStyle(
                                            color: AppColors.kNeutral800Color,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  _.individualLandTransferResult
                                                          ?.transerData ??
                                                      "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              text: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.landId
                                                      ?.city ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                              text: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.landId
                                                      ?.district ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              text: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.landId
                                                      ?.area ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                                              text: _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.landId
                                                      ?.province ??
                                                  "",
                                              style: TextStyle(
                                                color:
                                                    AppColors.kNeutral600Color,
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
                              "${_.individualLandTransferResult?.landSaleId?.landId?.address} (${_.individualLandTransferResult?.landSaleId?.landId?.surveyNo})",
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
                                    text: _.individualLandTransferResult
                                            ?.landSaleId?.landId?.wardNo ??
                                        "",
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
                                    text: DateFormat('d MMM, yyyy h:mm a')
                                        .format(_.individualLandTransferResult!
                                            .landSaleId!.landId!.createdAt!),
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
                              "Seller User Information",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _.individualLandTransferResult?.transerData ==
                                          "completed"
                                      ? _
                                                  .individualLandTransferResult
                                                  ?.ownerHistory
                                                  ?.imageFile
                                                  ?.imageUrl !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CustomNetworkImage(
                                                imageUrl: _
                                                    .individualLandTransferResult
                                                    ?.ownerHistory
                                                    ?.imageFile
                                                    ?.imageUrl,
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Icon(Icons.person),
                                            )
                                      : _
                                                  .individualLandTransferResult
                                                  ?.landSaleId
                                                  ?.ownerUserId
                                                  ?.imageFile
                                                  ?.imageUrl !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CustomNetworkImage(
                                                imageUrl: _
                                                    .individualLandTransferResult
                                                    ?.landSaleId
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
                                                _.individualLandTransferResult
                                                            ?.transerData ==
                                                        "completed"
                                                    ? _.individualLandTransferResult
                                                            ?.ownerHistory?.name ??
                                                        ""
                                                    : _
                                                            .individualLandTransferResult
                                                            ?.landSaleId
                                                            ?.ownerUserId
                                                            ?.name ??
                                                        "",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            _.individualLandTransferResult
                                                        ?.transerData ==
                                                    "completed"
                                                ? _.individualLandTransferResult
                                                            ?.ownerHistory?.id ==
                                                        AppSharedPreferences
                                                            .getUserId
                                                    ? const Icon(
                                                        Icons.verified_user,
                                                        color: Colors.green,
                                                      )
                                                    : Container()
                                                : _
                                                            .individualLandTransferResult
                                                            ?.landSaleId
                                                            ?.ownerUserId
                                                            ?.id ==
                                                        AppSharedPreferences
                                                            .getUserId
                                                    ? const Icon(
                                                        Icons.verified_user,
                                                        color: Colors.green,
                                                      )
                                                    : Container(),
                                          ],
                                        ),
                                        vSizedBox2,
                                        CustomText.ourText(
                                          _.individualLandTransferResult
                                                      ?.transerData ==
                                                  "completed"
                                              ? _.individualLandTransferResult
                                                      ?.ownerHistory?.email ??
                                                  ""
                                              : _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.ownerUserId
                                                      ?.email ??
                                                  "",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        vSizedBox2,
                                        CustomText.ourText(
                                          _.individualLandTransferResult
                                                      ?.transerData ==
                                                  "completed"
                                              ? _
                                                      .individualLandTransferResult
                                                      ?.ownerHistory
                                                      ?.phoneNumber ??
                                                  ""
                                              : _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.ownerUserId
                                                      ?.phoneNumber ??
                                                  "",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        vSizedBox2,
                                        CustomText.ourText(
                                          _.individualLandTransferResult
                                                      ?.transerData ==
                                                  "completed"
                                              ? _.individualLandTransferResult
                                                      ?.ownerHistory?.address ??
                                                  ""
                                              : _
                                                      .individualLandTransferResult
                                                      ?.landSaleId
                                                      ?.ownerUserId
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
                            vSizedBox3,
                            CustomText.ourText(
                              "Buyer User Information",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kBrandPrimaryColor,
                            ),
                            vSizedBox1,
                            _.individualLandTransferResult?.landSaleId
                                        ?.approvedUserId !=
                                    null
                                ? Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.kSecondaryBorderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _
                                                        .individualLandTransferResult
                                                        ?.approvedUserId
                                                        ?.user
                                                        ?.imageFile
                                                        ?.imageUrl !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CustomNetworkImage(
                                                      imageUrl: _
                                                          .individualLandTransferResult
                                                          ?.approvedUserId
                                                          ?.user
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomText.ourText(
                                                          _
                                                                  .individualLandTransferResult
                                                                  ?.approvedUserId
                                                                  ?.user
                                                                  ?.name ??
                                                              "",
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      _
                                                                  .individualLandTransferResult
                                                                  ?.approvedUserId
                                                                  ?.user
                                                                  ?.id ==
                                                              AppSharedPreferences
                                                                  .getUserId
                                                          ? const Icon(
                                                              Icons
                                                                  .verified_user,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  vSizedBox2,
                                                  CustomText.ourText(
                                                    _
                                                            .individualLandTransferResult
                                                            ?.approvedUserId
                                                            ?.user
                                                            ?.email ??
                                                        "",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  vSizedBox2,
                                                  CustomText.ourText(
                                                    _
                                                            .individualLandTransferResult
                                                            ?.approvedUserId
                                                            ?.user
                                                            ?.phoneNumber ??
                                                        "",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  vSizedBox2,
                                                  CustomText.ourText(
                                                    _
                                                            .individualLandTransferResult
                                                            ?.approvedUserId
                                                            ?.user
                                                            ?.address ??
                                                        "",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  vSizedBox2,
                                                  CustomText.ourText(
                                                    "Bidding Price : ${_.individualLandTransferResult?.approvedUserId?.landPrice}",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  vSizedBox2,
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            vSizedBox2,
                            vSizedBox1,
                            AppSharedPreferences.getUserId ==
                                    _.individualLandTransferResult?.ownerUserId
                                ? CustomButton.elevatedButton(
                                    "Initiate Land Transfer",
                                    () {
                                      _.initiateLandForTransfer(
                                        context: context,
                                        landTransferRequestModel:
                                            LandTransferRequestModel(
                                                landTransferId: _
                                                    .individualLandTransferResult
                                                    ?.id),
                                      );
                                    },
                                    isDisable: _.individualLandTransferResult
                                            ?.transerData !=
                                        "ongoing",
                                  )
                                : Container(),
                            vSizedBox1,
                            AppSharedPreferences.getUserId ==
                                    _.individualLandTransferResult
                                        ?.approvedUserId?.user?.id
                                ? CustomButton.elevatedButton(
                                    "Payment Form",
                                    () {
                                      navigate(
                                          context, const PaymentFormScreen());
                                    },
                                    isDisable: _.individualLandTransferResult
                                            ?.transerData !=
                                        "pending",
                                  )
                                : Container(),
                            vSizedBox1,
                            AppSharedPreferences.getUserId ==
                                        _.individualLandTransferResult
                                            ?.ownerUserId &&
                                    _.individualLandTransferResult
                                            ?.transerData ==
                                        "pending"
                                ? const Text.rich(
                                    TextSpan(
                                      text: "NOTE : ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                      children: [
                                        TextSpan(
                                            text:
                                                "Wait for the buyer to add payment Information.",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ))
                                      ],
                                    ),
                                  )
                                : Container(),
                            _.individualLandTransferResult?.transerData ==
                                    "initiated"
                                ? const Text.rich(
                                    TextSpan(
                                      text: "NOTE : ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                      children: [
                                        TextSpan(
                                            text:
                                                "The transfer has been initiated by seller. Wait for the admin to approve the transfership.",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ))
                                      ],
                                    ),
                                  )
                                : Container(),
                            vSizedBox2,
                            _.individualLandTransferResult?.billToken != null
                                ? Column(
                                    children: [
                                      vSizedBox1,
                                      CustomText.ourText(
                                        "Payment Information",
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.kBrandPrimaryColor,
                                      ),
                                      vSizedBox1,
                                      Card(
                                        elevation: 0,
                                        child: Container(
                                          padding: screenPadding,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppColors
                                                  .kSecondaryBorderColor,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CustomText.ourText(
                                                      "Bill Token :"),
                                                  CustomText.ourText(
                                                    _.individualLandTransferResult
                                                        ?.billToken,
                                                  ),
                                                ],
                                              ),
                                              vSizedBox1,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CustomText.ourText(
                                                      "Seller Acc :"),
                                                  CustomText.ourText(
                                                    _.individualLandTransferResult
                                                        ?.sellerBankAcc,
                                                  ),
                                                ],
                                              ),
                                              vSizedBox1,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CustomText.ourText(
                                                      "Buyer Acc :"),
                                                  CustomText.ourText(
                                                    _.individualLandTransferResult
                                                        ?.buyerBankAcc,
                                                  ),
                                                ],
                                              ),
                                              vSizedBox1,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CustomText.ourText(
                                                      "Transaction Amt :"),
                                                  CustomText.ourText(
                                                    _.individualLandTransferResult
                                                        ?.transactionAmt
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              vSizedBox1,
                                              CustomNetworkImage(
                                                height: 500,
                                                width: appWidth(context),
                                                boxFit: BoxFit.contain,
                                                imageUrl: _
                                                    .individualLandTransferResult
                                                    ?.voucherFormFile
                                                    ?.voucherFormImage,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            vSizedBox2,
                          ],
                        ),
                      )
                    : Container();
      }),
    );
  }
}
