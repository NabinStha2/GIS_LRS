import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:gis_flutter_frontend/providers/user_provider.dart';
import 'package:gis_flutter_frontend/utils/custom_toasts.dart';
import 'package:gis_flutter_frontend/utils/unfocus_keyboard.dart';
import 'package:gis_flutter_frontend/utils/validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../core/config/regex_config.dart';
import '../core/app/dimensions.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? pickedImage;
  XFile? pickedFrontImage;
  XFile? pickedBackImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Edit Profile",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: screenLeftRightPadding,
        child: Consumer<UserProvider>(
          builder: (context, _, child) => Form(
            key: _.editProfileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.ourText("FirstName"),
                vSizedBox1,
                CustomTextFormField(
                  fullNameString: true,
                  hintText: "FirstName",
                  controller: _.editFirstNameController,
                  validator: (val) => val.toString().isEmptyData()
                      ? "Cannot be empty"
                      : !RegexConfig.textRegex.hasMatch(val)
                          ? "Name not valid"
                          : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomText.ourText("LastName"),
                vSizedBox1,
                CustomTextFormField(
                  fullNameString: true,
                  hintText: "LastName",
                  controller: _.editLastNameController,
                  validator: (val) => val.toString().isEmptyData()
                      ? "Cannot be empty"
                      : !RegexConfig.textRegex.hasMatch(val)
                          ? "Name not valid"
                          : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomText.ourText("Address"),
                vSizedBox1,
                CustomTextFormField(
                  fullNameString: true,
                  hintText: "Address",
                  controller: _.editAddressController,
                  validator: (val) =>
                      val.toString().isEmptyData() ? "Cannot be empty" : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomText.ourText("Phone Number"),
                vSizedBox1,
                CustomTextFormField(
                  fullNameString: true,
                  hintText: "Phone Number",
                  controller: _.editPhoneNumberController,
                  onlyNumber: true,
                  textInputType: TextInputType.number,
                  validator: (val) => val.toString().isEmptyData()
                      ? "Cannot be empty"
                      : !RegexConfig.numberRegex.hasMatch(val)
                          ? "Phone number not valid"
                          : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomText.ourText("CitizenShip No"),
                vSizedBox1,
                CustomTextFormField(
                  fullNameString: true,
                  hintText: "CitizenShip No",
                  controller: _.editCitizenshipNoController,
                  validator: (val) =>
                      val.toString().isEmptyData() ? "Cannot be empty" : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomText.ourText("User Image"),
                vSizedBox1,
                Row(
                  children: [
                    CustomButton.elevatedButton(
                      "upload image",
                      () async {
                        pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        logger(pickedImage);
                        setState(() {});
                        if (pickedImage != null) {
                          _.updateUserImage(
                            context: context,
                            file: File(pickedImage?.path ?? ""),
                            isUserImage: true,
                          );
                        }
                      },
                      borderRadius: 16,
                    ),
                    hSizedBox2,
                    Expanded(
                      child: pickedImage != null
                          ? Image.file(
                              File(pickedImage?.path ?? ""),
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    ),
                  ],
                ),
                vSizedBox2,
                CustomText.ourText("Front Document"),
                vSizedBox1,
                Row(
                  children: [
                    CustomButton.elevatedButton(
                      "upload front image",
                      () async {
                        pickedFrontImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        logger(pickedFrontImage);
                        setState(() {});
                        if (pickedFrontImage != null) {
                          _.updateUserImage(
                            context: context,
                            file: File(pickedFrontImage?.path ?? ""),
                            isFrontDocumentImage: true,
                          );
                        }
                      },
                      borderRadius: 16,
                    ),
                    hSizedBox2,
                    Expanded(
                      child: pickedFrontImage != null
                          ? Image.file(
                              File(pickedFrontImage?.path ?? ""),
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    ),
                  ],
                ),
                vSizedBox2,
                CustomText.ourText("Back Document"),
                vSizedBox1,
                Row(
                  children: [
                    CustomButton.elevatedButton(
                      "upload back image",
                      () async {
                        pickedBackImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        logger(pickedBackImage);
                        setState(() {});
                        if (pickedBackImage != null) {
                          _.updateUserImage(
                            context: context,
                            file: File(pickedBackImage?.path ?? ""),
                          );
                        }
                      },
                      borderRadius: 16,
                    ),
                    hSizedBox2,
                    Expanded(
                      child: pickedBackImage != null
                          ? Image.file(
                              File(pickedBackImage?.path ?? ""),
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
                  "Save Changes",
                  () {
                    if (_.editProfileFormKey.currentState?.validate() ??
                        false) {
                      unfocusKeyboard(context);
                      _.updateUserProfile(context: context);
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
      ),
    );
  }
}
