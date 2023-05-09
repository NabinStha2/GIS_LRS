// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/model/transfer_land/land_transfer_request_model.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';

import '../core/app/colors.dart';
import '../core/routing/route_navigation.dart';
import '../model/land/individual_land_sale_response_model.dart';
import '../model/land/land_request_model.dart';
import '../providers/land_transfer_provider.dart';
import '../utils/custom_toasts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_network_image_widget.dart';
import '../widgets/custom_text.dart';
import 'map_page.dart';

class LandSaleDetailsScreen extends StatefulWidget {
  final String? landSaleId;
  const LandSaleDetailsScreen({
    Key? key,
    this.landSaleId,
  }) : super(key: key);

  @override
  State<LandSaleDetailsScreen> createState() => _LandSaleDetailsScreenState();
}

class _LandSaleDetailsScreenState extends State<LandSaleDetailsScreen> {
  double? lat;
  double? long;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getIndividualSaleLand(
          context: context,
          landRequestModel: LandRequestModel(
            landSaleId: widget.landSaleId,
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land Sale Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Consumer2<LandProvider, LandTransferProvider>(
          builder: (context, _, __, child) {
        _.individualSaleLandResult?.geoJson?.geometry?.coordinates
            ?.forEach((element) {
          long = element[0][0];
          lat = element[0][1];
        });
        return _.isLoading
            ? const CustomCircularProgressIndicatorWidget(
                title: "Loading individual land sale...",
              )
            : _.getIndividualSaleLandMessage != null
                ? Center(
                    child: CustomText.ourText(_.getIndividualSaleLandMessage,
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
                          color: AppColors.kPrimaryColor2,
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
                                                .individualSaleLandResult
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
                                                  .individualSaleLandResult
                                                  ?.geoJson
                                                  ?.id,
                                              latlngData: LatLng(
                                                lat ?? 0.0,
                                                long ?? 0.0,
                                              ), // latlngData: LatLng(
                                              //     double.parse(_
                                              //             .individualSaleLandResult
                                              //             ?.landId
                                              //             ?.polygon?[0]
                                              //             .latitude ??
                                              //         "0"),
                                              //     double.parse(_
                                              //             .individualSaleLandResult
                                              //             ?.landId
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
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.id ??
                                              "",
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
                                          text: _.individualSaleLandResult
                                                  ?.landId?.parcelId ??
                                              "",
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
                                      text: "Price: NPR. ",
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.landPrice ??
                                              "",
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
                                          text: _.individualSaleLandResult
                                                  ?.saleData ??
                                              "",
                                          style: TextStyle(
                                            color: AppColors.kHeadingColor,
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
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.city ??
                                              "",
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
                                      text: "District: ",
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.district ??
                                              "",
                                          style: TextStyle(
                                            color: AppColors.kHeadingColor,
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
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.area ??
                                              "",
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
                                      text: "Province: ",
                                      style: const TextStyle(
                                        color: AppColors.kTextPrimaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _.individualSaleLandResult
                                                  ?.landId?.province ??
                                              "",
                                          style: TextStyle(
                                            color: AppColors.kHeadingColor,
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
                          color: AppColors.kTextPrimaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        vSizedBox0,
                        CustomText.ourText(
                          "${_.individualSaleLandResult?.landId?.address} (${_.individualSaleLandResult?.landId?.surveyNo})",
                          color: AppColors.kHeadingColor,
                          fontWeight: FontWeight.w400,
                        ),
                        vSizedBox2,
                        Text.rich(
                          TextSpan(
                            text: "Ward No: ",
                            style: const TextStyle(
                              color: AppColors.kTextPrimaryColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: _.individualSaleLandResult?.landId
                                        ?.wardNo ??
                                    "",
                                style: TextStyle(
                                  color: AppColors.kHeadingColor,
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
                            style: const TextStyle(
                              color: AppColors.kTextPrimaryColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: DateFormat('d MMM, yyyy h:mm a').format(_
                                    .individualSaleLandResult!
                                    .landId!
                                    .createdAt!),
                                style: TextStyle(
                                  color: AppColors.kHeadingColor,
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
                          color: AppColors.kPrimaryColor2,
                        ),
                        vSizedBox1,
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.kBorderColor,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _.individualSaleLandResult?.ownerUserId?.imageFile
                                          ?.imageUrl !=
                                      null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CustomNetworkImage(
                                        imageUrl: _.individualSaleLandResult
                                            ?.ownerUserId?.imageFile?.imageUrl,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText.ourText(
                                            _.individualSaleLandResult
                                                    ?.ownerUserId?.name ??
                                                "",
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        _.individualSaleLandResult?.ownerUserId
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
                                      _.individualSaleLandResult?.ownerUserId
                                              ?.email ??
                                          "",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    vSizedBox2,
                                    CustomText.ourText(
                                      _.individualSaleLandResult?.ownerUserId
                                              ?.phoneNumber ??
                                          "",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    vSizedBox2,
                                    CustomText.ourText(
                                      _.individualSaleLandResult?.ownerUserId
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
                        AppSharedPreferences.getUserId ==
                                    _.individualSaleLandResult?.ownerUserId
                                        ?.id &&
                                _.individualSaleLandResult?.landId
                                        ?.isVerified ==
                                    "approved"
                            ? CustomButton.elevatedButton(
                                _.individualSaleLandResult?.saleData ==
                                            "selling" ||
                                        _.individualSaleLandResult?.saleData ==
                                            "processing" ||
                                        _.individualSaleLandResult?.saleData ==
                                            "transferring"
                                    ? "Cancel land for sale"
                                    : "Add Land For Sale",
                                () {
                                  _.individualSaleLandResult?.saleData ==
                                          "selling"
                                      ? Provider.of<LandProvider>(context,
                                              listen: false)
                                          .deleteSaleLand(
                                              context: context,
                                              landRequestModel:
                                                  LandRequestModel(
                                                landId: _
                                                    .individualSaleLandResult
                                                    ?.landId
                                                    ?.id,
                                                landSaleId: widget.landSaleId,
                                              ))
                                      : Provider.of<LandProvider>(context,
                                              listen: false)
                                          .addSaleLand(
                                              context: context,
                                              landRequestModel:
                                                  LandRequestModel(
                                                landId: _
                                                    .individualSaleLandResult
                                                    ?.landId
                                                    ?.id,
                                              ));
                                },
                                isDisable:
                                    _.individualSaleLandResult?.saleData ==
                                            "processing" ||
                                        _.individualSaleLandResult?.saleData ==
                                            "transferring",
                              )
                            : Container(),
                        vSizedBox1,
                        AppSharedPreferences.getUserId ==
                                _.individualSaleLandResult?.ownerUserId?.id
                            ? Container()
                            : _.individualSaleLandResult?.requestedUserId
                                        ?.firstWhere(
                                            (element) =>
                                                element.id ==
                                                AppSharedPreferences.getUserId,
                                            orElse: () => UserId())
                                        .id !=
                                    AppSharedPreferences.getUserId
                                ? _.individualSaleLandResult?.approvedUserId ==
                                        null
                                    ? CustomButton.elevatedButton(
                                        "Request to buy land",
                                        () {
                                          Provider.of<LandProvider>(context,
                                                  listen: false)
                                              .requestToBuySaleLand(
                                            context: context,
                                            landRequestModel: LandRequestModel(
                                              landSaleId: _
                                                  .individualSaleLandResult?.id,
                                            ),
                                          );
                                        },
                                      )
                                    : CustomText.ourText(
                                        "Land has been proccessed already",
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      )
                                : CustomText.ourText(
                                    "Land is already requested to buy",
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                        vSizedBox2,
                        CustomText.ourText(
                          "Requested To Buy Land User Information",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kPrimaryColor2,
                        ),
                        vSizedBox1,
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _.individualSaleLandResult?.requestedUserId
                                  ?.length ??
                              0,
                          separatorBuilder: (context, index) => vSizedBox1,
                          itemBuilder: (context, index) {
                            var data = _.individualSaleLandResult
                                ?.requestedUserId?[index];
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.kBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      data?.imageFile?.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CustomNetworkImage(
                                                imageUrl:
                                                    data?.imageFile?.imageUrl,
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
                                                  child: CustomText.ourText(
                                                    data?.name ?? "",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                data?.id ==
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
                                              data?.email ?? "",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                            CustomText.ourText(
                                              data?.phoneNumber ?? "",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                            CustomText.ourText(
                                              data?.address ?? "",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  vSizedBox1,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppSharedPreferences.getUserId ==
                                                    _.individualSaleLandResult
                                                        ?.ownerUserId?.id &&
                                                _.individualSaleLandResult
                                                        ?.approvedUserId ==
                                                    null
                                            ? CustomButton.elevatedButton(
                                                "Accept buy land",
                                                () {
                                                  Provider.of<LandProvider>(
                                                          context,
                                                          listen: false)
                                                      .acceptToBuySaleLand(
                                                    context: context,
                                                    acceptedUserId: data?.id,
                                                    landRequestModel:
                                                        LandRequestModel(
                                                      landSaleId: _
                                                          .individualSaleLandResult
                                                          ?.id,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ),
                                      hSizedBox2,
                                      Expanded(
                                        child: AppSharedPreferences.getUserId ==
                                                _.individualSaleLandResult
                                                    ?.ownerUserId?.id
                                            ? CustomButton.elevatedButton(
                                                "Reject buy land",
                                                () {
                                                  Provider.of<LandProvider>(
                                                          context,
                                                          listen: false)
                                                      .rejectToBuySaleLand(
                                                    context: context,
                                                    rejectedUserId: data?.id,
                                                    landRequestModel:
                                                        LandRequestModel(
                                                      landSaleId: _
                                                          .individualSaleLandResult
                                                          ?.id,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                  vSizedBox1,
                                ],
                              ),
                            );
                          },
                        ),
                        vSizedBox2,
                        CustomText.ourText(
                          "Accepted Buyer User Information",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kPrimaryColor2,
                        ),
                        vSizedBox1,
                        _.individualSaleLandResult?.approvedUserId != null
                            ? Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.kBorderColor,
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
                                                    .individualSaleLandResult
                                                    ?.approvedUserId
                                                    ?.imageFile
                                                    ?.imageUrl !=
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CustomNetworkImage(
                                                  imageUrl: _
                                                      .individualSaleLandResult
                                                      ?.approvedUserId
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
                                                    child: CustomText.ourText(
                                                      _.individualSaleLandResult
                                                              ?.approvedUserId?.name ??
                                                          "",
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  _.individualSaleLandResult
                                                              ?.approvedUserId?.id ==
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
                                                _
                                                        .individualSaleLandResult
                                                        ?.approvedUserId
                                                        ?.email ??
                                                    "",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              vSizedBox2,
                                              CustomText.ourText(
                                                _
                                                        .individualSaleLandResult
                                                        ?.approvedUserId
                                                        ?.phoneNumber ??
                                                    "",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              vSizedBox2,
                                              CustomText.ourText(
                                                _
                                                        .individualSaleLandResult
                                                        ?.approvedUserId
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
                                    vSizedBox1,
                                    AppSharedPreferences.getUserId ==
                                            _.individualSaleLandResult
                                                ?.ownerUserId?.id
                                        ? CustomButton.elevatedButton(
                                            "Start Transferring Land",
                                            () {
                                              __.addLandForTransfer(
                                                context: context,
                                                landTransferRequestModel:
                                                    LandTransferRequestModel(
                                                        landSaleId: _
                                                            .individualSaleLandResult
                                                            ?.id),
                                              );
                                            },
                                            isDisable:
                                                _.individualSaleLandResult
                                                            ?.saleData ==
                                                        "transferring" &&
                                                    _.individualSaleLandResult
                                                            ?.saleData !=
                                                        "processing",
                                          )
                                        : Container(),
                                    vSizedBox0,
                                    (_.individualSaleLandResult?.ownerUserId
                                                        ?.id ==
                                                    AppSharedPreferences
                                                        .getUserId ||
                                                _.individualSaleLandResult
                                                        ?.approvedUserId?.id ==
                                                    AppSharedPreferences
                                                        .getUserId) &&
                                            _.individualSaleLandResult
                                                    ?.saleData ==
                                                "transferring"
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
                                                        "Land transferring has been started & both the user must accept the transfer to fully transfer the land.",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ))
                                              ],
                                            ),
                                          )
                                        : (_.individualSaleLandResult
                                                            ?.ownerUserId?.id ==
                                                        AppSharedPreferences
                                                            .getUserId ||
                                                    _.individualSaleLandResult
                                                            ?.approvedUserId?.id ==
                                                        AppSharedPreferences
                                                            .getUserId) &&
                                                _.individualSaleLandResult
                                                        ?.saleData ==
                                                    "processing"
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
                                                            "Wait for the land owner to start the land transfer.",
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ))
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                  ],
                                ),
                              )
                            : Container(),
                        vSizedBox2,
                        CustomText.ourText(
                          "Rejected Buyer User Information",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kPrimaryColor2,
                        ),
                        vSizedBox1,
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _.individualSaleLandResult?.rejectedUserId
                                  ?.length ??
                              0,
                          separatorBuilder: (context, index) => vSizedBox1,
                          itemBuilder: (context, index) {
                            var data = _.individualSaleLandResult
                                ?.rejectedUserId?[index];
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.kBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      data?.imageFile?.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CustomNetworkImage(
                                                imageUrl:
                                                    data?.imageFile?.imageUrl,
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
                                              children: [
                                                Expanded(
                                                  child: CustomText.ourText(
                                                    data?.name ?? "",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                hSizedBox2,
                                                data?.id ==
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
                                              data?.email ?? "",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                            CustomText.ourText(
                                              data?.phoneNumber ?? "",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                            CustomText.ourText(
                                              data?.address ?? "",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            vSizedBox2,
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  vSizedBox0,
                                  data?.id == AppSharedPreferences.getUserId
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
                                                      "You have been rejected to buy the land.",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ))
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          },
                        ),
                        vSizedBox2,
                      ],
                    ),
                  );
      }),
    );
  }
}
