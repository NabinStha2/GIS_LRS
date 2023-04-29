import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';

import '../core/config/api_config.dart';
import '../core/development/console.dart';
import '../model/user/user_response_model.dart';
import '../services/base_client.dart';
import '../services/base_client_controller.dart';
import '../utils/app_shared_preferences.dart';
import '../widgets/custom_dialogs.dart';

class UserProvider extends ChangeNotifier with BaseController {
  var userData = UserData();
  bool isLoading = false;
  File? userImageFile;

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController editFirstNameController = TextEditingController();
  final TextEditingController editLastNameController = TextEditingController();
  final TextEditingController editPhoneNumberController =
      TextEditingController();
  final TextEditingController editAddressController = TextEditingController();
  final TextEditingController editCitizenshipNoController =
      TextEditingController();

  String get getUserFullName => "${userData.firstName} ${userData.lastName}";

  clearUserField() {
    editAddressController.clear();
    editCitizenshipNoController.clear();
    editFirstNameController.clear();
    editLastNameController.clear();
    editPhoneNumberController.clear();
  }

  getUser({required BuildContext ctx}) async {
    try {
      isLoading = true;
      var userId = AppSharedPreferences.getUserId;
      consolelog(userId);
      var response = await BaseClient()
          .get(
            ApiConfig.baseUrl,
            "${ApiConfig.userUrl}/$userId",
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      var decodedJson = userResponseModelFromJson(response);
      userData = decodedJson.data?.userData ?? UserData();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      consolelog(e.toString());
    }
  }

  updateUserProfile({required BuildContext context}) async {
    try {
      isLoading = true;
      CustomDialogs.fullLoadingDialog(
          data: "Updating, Please wait...", context: context);
      var userId = AppSharedPreferences.getUserId;
      consolelog(userId);
      var response = await BaseClient()
          .patch(
            ApiConfig.baseUrl,
            "${ApiConfig.userUrl}/$userId${ApiConfig.userUpdateUrl}",
            {
              "firstName": editFirstNameController.text,
              "lastName": editLastNameController.text,
              "phoneNumber": editPhoneNumberController.text,
              "address": editAddressController.text,
              "citizenShipNo": editCitizenshipNoController.text,
            },
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      var decodedJson = userResponseModelFromJson(response);
      userData = decodedJson.data?.userData ?? UserData();
      isLoading = false;
      hideLoading(context);
      back(context);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      consolelog(e.toString());
    }
  }

  updateUserImage({
    required BuildContext context,
    required File file,
    bool? isUserImage,
    bool? isFrontDocumentImage,
  }) async {
    try {
      isLoading = true;
      CustomDialogs.fullLoadingDialog(data: "Uploading", context: context);

      var userId = AppSharedPreferences.getUserId;
      consolelog(userId);
      var response = await BaseClient()
          .postWithImage(
            ApiConfig.baseUrl,
            "${ApiConfig.userUrl}/$userId${isUserImage ?? false ? ApiConfig.userImageUrl : isFrontDocumentImage ?? false ? ApiConfig.frontCitizenshipImageUrl : ApiConfig.backCitizenshipImageUrl}",
            imageKey: isUserImage ?? false
                ? "userImage"
                : isFrontDocumentImage ?? false
                    ? "frontCitizenshipImage"
                    : "backCitizenshipImage",
            imgFiles: [file],
            method: "PATCH",
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      var decodedJson = userResponseModelFromJson(response);
      userData = decodedJson.data?.userData ?? UserData();
      isLoading = false;
      hideLoading(context);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      consolelog(e.toString());
    }
  }
}
