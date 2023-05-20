// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/colors.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/model/transfer_land/land_transfer_request_model.dart';
import 'package:gis_flutter_frontend/providers/land_transfer_provider.dart';
import 'package:gis_flutter_frontend/utils/validation.dart';
import 'package:gis_flutter_frontend/widgets/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/development/console.dart';
import '../core/routing/route_navigation.dart';
import '../utils/custom_toasts.dart';
import '../utils/unfocus_keyboard.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText.ourText(
            "Payment Form",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        body: Consumer<LandTransferProvider>(
          builder: (context, _, child) => SingleChildScrollView(
            padding: screenLeftRightPadding,
            child: Form(
              key: _.paymentFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.ourText("Seller Acc"),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Seller Account Number",
                    controller: _.sellerBankAcc,
                    validator: (val) =>
                        val.toString().isEmptyData() ? "Cannot be empty" : null,
                    textInputAction: TextInputAction.next,
                  ),
                  vSizedBox2,
                  CustomText.ourText("Bill Token"),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Bill Token Number",
                    controller: _.billToken,
                    onlyNumber: true,
                    textInputType: TextInputType.number,
                    validator: (val) =>
                        val.toString().isEmptyData() ? "Cannot be empty" : null,
                    textInputAction: TextInputAction.next,
                  ),
                  vSizedBox2,
                  CustomText.ourText("Buyer Acc"),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Buyer Acc Number",
                    controller: _.buyerBankAcc,
                    validator: (val) =>
                        val.toString().isEmptyData() ? "Cannot be empty" : null,
                    textInputAction: TextInputAction.next,
                  ),
                  vSizedBox2,
                  CustomText.ourText("Transaction Amt"),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Transaction Amount",
                    controller: _.transactionAmt,
                    onlyNumber: true,
                    textInputType: TextInputType.number,
                    validator: (val) =>
                        val.toString().isEmptyData() ? "Cannot be empty" : null,
                    textInputAction: TextInputAction.done,
                  ),
                  vSizedBox2,
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, innerSetState) => Container(
                                padding: screenPadding,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    vSizedBox2,
                                    CustomButton.elevatedButton(
                                      "Choose from gallery",
                                      () async {
                                        back(context);
                                        pickedImage = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        logger(pickedImage?.path);
                                        int size = File(pickedImage?.path ?? '')
                                            .lengthSync();
                                        if (size > 5000000) {
                                          pickedImage = null;
                                          errorToast(
                                              msg:
                                                  "Image size must be less than 5mb.");
                                        }
                                        if (pickedImage != null) {
                                          _.addPaymentVoucherFormLandForTransfer(
                                            context: context,
                                            landTransferRequestModel:
                                                LandTransferRequestModel(
                                                    landTransferId: _
                                                        .individualLandTransferResult
                                                        ?.id),
                                            file: File(pickedImage?.path ?? ""),
                                          );
                                        }

                                        setState(() {});
                                      },
                                    ),
                                    vSizedBox2,
                                    CustomButton.elevatedButton(
                                      "Take Photo",
                                      () async {
                                        back(context);
                                        pickedImage = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        logger(pickedImage);
                                        int size = File(pickedImage?.path ?? '')
                                            .lengthSync();
                                        if (size > 5000000) {
                                          pickedImage = null;
                                          errorToast(
                                              msg:
                                                  "Image size must be less than 5mb.");
                                        }
                                        if (pickedImage != null) {
                                          consolelog(pickedImage?.path);
                                          _.addPaymentVoucherFormLandForTransfer(
                                            context: context,
                                            landTransferRequestModel:
                                                LandTransferRequestModel(
                                                    landTransferId: _
                                                        .individualLandTransferResult
                                                        ?.id),
                                            file: File(pickedImage?.path ?? ""),
                                          );
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    vSizedBox2,
                                    pickedImage != null
                                        ? CustomButton.elevatedButton(
                                            "Clear",
                                            () async {
                                              back(context);
                                              pickedImage = null;
                                              setState(() {});
                                            },
                                            color: Colors.red,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: screenPadding,
                      width: appWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.kSecondaryBorderColor,
                        ),
                      ),
                      child: pickedImage == null
                          ? Row(
                              children: [
                                const Icon(Icons.camera_alt_outlined),
                                hSizedBox1,
                                CustomText.ourText("Upload voucher form"),
                              ],
                            )
                          : Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    File(pickedImage?.path ?? ""),
                                    height: 150,
                                    width: appWidth(context),
                                  ),
                                ),
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        pickedImage = null;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  // Container(
                  //   padding: screenPadding,
                  //   height: 100,
                  //   width: appWidth(context),
                  //   child: const DashedRect(
                  //     color: Colors.grey,
                  //     strokeWidth: 2.0,
                  //     gap: 3.0,
                  //   ),
                  // ),
                  vSizedBox2,
                  CustomButton.elevatedButton(
                    "Save Changes",
                    () {
                      if (_.paymentFormKey.currentState?.validate() ?? false) {
                        unfocusKeyboard(context);
                        _.addPaymentFormLandForTransfer(
                            context: context,
                            landTransferRequestModel: LandTransferRequestModel(
                              landTransferId:
                                  _.individualLandTransferResult?.id,
                            ));
                        back(context);
                      } else {
                        errorToast(msg: "Please validate all field");
                      }
                    },
                  ),
                  vSizedBox2,
                ],
              ),
            ),
          ),
        ));
  }
}
