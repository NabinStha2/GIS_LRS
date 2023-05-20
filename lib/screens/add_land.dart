import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/utils/custom_toasts.dart';
import 'package:gis_flutter_frontend/utils/validation.dart';
import 'package:gis_flutter_frontend/widgets/custom_button.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/app/dimensions.dart';
import '../core/config/regex_config.dart';
import '../core/development/console.dart';
import '../providers/land_provider.dart';
import '../widgets/custom_text_form_field.dart';

ValueNotifier<int> textFormFieldLength = ValueNotifier<int>(3);

class AddLandScreen extends StatefulWidget {
  const AddLandScreen({super.key});

  @override
  State<AddLandScreen> createState() => _AddLandScreenState();
}

class _AddLandScreenState extends State<AddLandScreen> {
  XFile? pickedLandCertificateDocument;

  @override
  void initState() {
    super.initState();

    // debugPrint(
    //     "from init of add land :: ${Provider.of<LandProvider>(context, listen: false).textEditingControllers.length.toString()}");
    // textFormFieldLength.value = 3;
    // Provider.of<LandProvider>(context, listen: false)
    //     .textEditingControllers
    //     .clear();
    // List.generate(3, (index) {
    //   TextEditingController textEditingController = TextEditingController();
    //   Provider.of<LandProvider>(context, listen: false)
    //       .textEditingControllers
    //       .add(textEditingController);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText("Add Land"),
      ),
      body: Consumer<LandProvider>(
        builder: (context, _, child) => Padding(
          padding: screenLeftRightPadding,
          child: Form(
            key: _.addLandFormKey,
            child: ValueListenableBuilder(
              valueListenable: textFormFieldLength,
              builder: (context, val, c) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vSizedBox2,
                      CustomText.ourText("Parcel Id"),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "Parcel Id",
                        controller: _.parcelIdController,
                        onlyNumber: true,
                        textInputType: TextInputType.number,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : !RegexConfig.numberRegex.hasMatch(val)
                                ? "Parcel Id not valid"
                                : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      CustomText.ourText("Map Sheet No."),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "Map Sheet No.",
                        controller: _.mapsheetNoController,
                        onlyNumber: true,
                        textInputType: TextInputType.number,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : !RegexConfig.numberRegex.hasMatch(val)
                                ? "MapSheet no. not valid"
                                : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      CustomText.ourText("City"),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "City",
                        controller: _.cityController,
                        fullNameString: true,
                        textInputType: TextInputType.text,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      CustomText.ourText("Ward No."),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "Ward No",
                        controller: _.wardNoController,
                        onlyNumber: true,
                        textInputType: TextInputType.number,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : !RegexConfig.wardNoRegrex
                                    .hasMatch(_.wardNoController.text.trim())
                                ? "Ward Number not valid"
                                : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      // CustomText.ourText("Area"),
                      // vSizedBox1,
                      // CustomTextFormField(
                      //   hintText: "Area",
                      //   controller: _.areaController,
                      //   textInputType: TextInputType.number,
                      //   validator: (val) => val.toString().isEmptyData()
                      //       ? "Cannot be empty"
                      //       : !RegexConfig.numberRegex.hasMatch(val)
                      //           ? "Area not valid"
                      //           : null,
                      //   textInputAction: TextInputAction.next,
                      //   doubleNumber: true,
                      // ),
                      // vSizedBox2,
                      CustomText.ourText("Province"),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "Province",
                        controller: _.provinceController,
                        fullNameString: true,
                        textInputType: TextInputType.text,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      CustomText.ourText("District"),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "District",
                        controller: _.districtController,
                        fullNameString: true,
                        textInputType: TextInputType.text,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      // CustomText.ourText("Land Price"),
                      // vSizedBox1,
                      // CustomTextFormField(
                      //   hintText: "Land Price",
                      //   controller: _.landPriceController,
                      //   doubleNumber: true,
                      //   textInputType: TextInputType.number,
                      //   validator: (val) => val.toString().isEmptyData()
                      //       ? "Cannot be empty"
                      //       : !RegexConfig.numberRegex.hasMatch(val)
                      //           ? "Land Price not valid"
                      //           : null,
                      //   textInputAction: TextInputAction.next,
                      // ),
                      // vSizedBox2,
                      CustomText.ourText("Street"),
                      vSizedBox1,
                      CustomTextFormField(
                        hintText: "Street",
                        controller: _.streetController,
                        fullNameString: true,
                        textInputType: TextInputType.text,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                      vSizedBox2,
                      // CustomText.ourText("Polygon"),
                      // vSizedBox1,
                      // Column(
                      //   children: List.generate(
                      //     textFormFieldLength.value,
                      //     (index) => Column(
                      //       children: [
                      //         CustomTextFormField(
                      //           textInputType: TextInputType.number,
                      //           controller: Provider.of<LandProvider>(context,
                      //                   listen: false)
                      //               .textEditingControllers[index],
                      //           validator: (val) {
                      //             return val?.isEmpty ?? false
                      //                 ? "cannot be empty"
                      //                 : null;
                      //           },
                      //           hintText: "24.42 , 23.45",
                      //         ),
                      //         vSizedBox1,
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: SizedBox(
                      //     width: 80,
                      //     child: CustomButton.textButton(
                      //       "Add more",
                      //       () {
                      //         textFormFieldLength.value++;
                      //         TextEditingController textEditingController =
                      //             TextEditingController();
                      //         Provider.of<LandProvider>(context, listen: false)
                      //             .textEditingControllers
                      //             .add(textEditingController);
                      //       },
                      //       color: Colors.transparent,
                      //       isFitted: true,
                      //       titleColor: AppColors.kPrimaryColor2,
                      //     ),
                      //   ),
                      // ),
                      CustomText.ourText("Land Certificate Document"),
                      vSizedBox1,
                      Row(
                        children: [
                          CustomButton.elevatedButton(
                            "upload image",
                            () async {
                              pickedLandCertificateDocument =
                                  await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                              logger(pickedLandCertificateDocument);
                              int size = File(
                                      pickedLandCertificateDocument?.path ?? '')
                                  .lengthSync();
                              if (size > 5000000) {
                                pickedLandCertificateDocument = null;
                                errorToast(
                                    msg: "Image size must be less than 5mb.");
                              }
                              setState(() {});
                              // if (pickedLandCertificateDocument != null) {
                              //   // _.updateUserImage(
                              //   //   context: context,
                              //   //   file: File(
                              //   //       pickedLandCertificateDocument?.path ??
                              //   //           ""),
                              //   // );
                              // }
                            },
                            borderRadius: 16,
                          ),
                          hSizedBox2,
                          Expanded(
                            child: pickedLandCertificateDocument != null
                                ? Image.file(
                                    File(pickedLandCertificateDocument?.path ??
                                        ""),
                                    width: 100,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      vSizedBox3,
                      CustomButton.elevatedButton(
                        "Add Land",
                        () {
                          if (_.addLandFormKey.currentState?.validate() ??
                              false) {
                            if (pickedLandCertificateDocument != null) {
                              _.addLand(
                                context: context,
                                file: File(
                                    pickedLandCertificateDocument?.path ?? ""),
                                //  polygonData: latlngTempList
                              );
                            } else {
                              errorToast(
                                  msg: "Land certificate must be provided");
                            }
                            // var latlngTempList = <Map<String, dynamic>>[];
                            // for (var e in Provider.of<LandProvider>(context,
                            //         listen: false)
                            //     .textEditingControllers) {
                            //   latlngTempList.add({
                            //     "latitude":
                            //         double.parse(e.text.split(",")[0].trim()),
                            //     "longitude":
                            //         double.parse(e.text.split(",")[1].trim())
                            //   });
                            // }
                            // consolelog(latlngTempList);

                            // var latlngTempList = <LatLng>[];
                            // for (var e in textEditingControllers) {
                            //   latlngTempList.add(LatLng(
                            //       double.parse(e.text.split(",")[0].trim()),
                            //       double.parse(e.text.split(",")[1].trim())));
                            // }
                            // latlngList.value.add(latlngTempList);
                            // debugPrint(latlngTempList.toString());
                            // debugPrint(latlngList.value.toString());
                          } else {
                            errorToast(msg: "Please validate all fields.");
                          }
                        },
                      ),
                      vSizedBox2,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
