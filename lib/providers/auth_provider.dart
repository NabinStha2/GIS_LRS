// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_name.dart';
import 'package:gis_flutter_frontend/providers/drawer_provider.dart';
import 'package:gis_flutter_frontend/services/local_notification_service.dart';
import 'package:provider/provider.dart';

import '../core/app/enums.dart';
import '../core/config/api_config.dart';
import '../core/development/console.dart';
import '../core/routing/route_navigation.dart';
import '../model/login/login_response_model.dart';
import '../screens/register/register_screen.dart';
import '../services/base_client.dart';
import '../services/base_client_controller.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/custom_toasts.dart';
import '../utils/unfocus_keyboard.dart';
import '../widgets/custom_dialogs.dart';

class AuthProvider extends ChangeNotifier with BaseController {
  var loginResponseModel = LoginResponseModel();
  bool isLoggedIn = AppSharedPreferences.getAuthToken != null &&
          AppSharedPreferences.getAuthToken != ""
      ? true
      : false;
  bool isHideLoginPassword = true;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<FormState> _loginUserFormKey = GlobalKey<FormState>();
  get loginUserFormKey => _loginUserFormKey;

  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerPhoneNumberController = TextEditingController();
  TextEditingController registerFirstNameController = TextEditingController();
  TextEditingController registerLastNameController = TextEditingController();
  TextEditingController registerAddressController = TextEditingController();
  TextEditingController pinputController = TextEditingController();
  final GlobalKey<FormState> _registerUserFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get registerUserFormKey => _registerUserFormKey;
  final GlobalKey<FormState> _pinputKey = GlobalKey<FormState>();
  GlobalKey<FormState> get pinputKey => _pinputKey;

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  clearLoginBodyTextFieldValue() {
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  login(
      {required BuildContext ctx,
      required String? userEmail,
      required String? userPassword}) async {
    try {
      var registrationIdToken =
          await LocalNotificationService.getDeviceTokenToSendNotification();
      Map data = {
        "email": userEmail?.trim(),
        "password": userPassword,
        "registrationIdToken": registrationIdToken,
      };
      CustomDialogs.fullLoadingDialog(data: "Logging", context: ctx);
      var response = await BaseClient()
          .post(ApiConfig.baseUrl, ApiConfig.userUrl + ApiConfig.loginUrl, data,
              hasTokenHeader: false)
          .catchError(handleError);
      if (response == null) return null;
      loginResponseModel = loginResponseModelFromJson(response);
      AppSharedPreferences.setAuthToken(loginResponseModel.data?.token ?? "");
      AppSharedPreferences.setUserId(
          loginResponseModel.data?.userData?.id ?? "");
      AppSharedPreferences.setRememberMe(true);
      clearLoginBodyTextFieldValue();
      unfocusKeyboard(ctx);
      hideLoading(ctx);
      navigateOffAllNamed(ctx, RouteName.dashboardRouteName);
      isLoggedIn = true;
      notifyListeners();
      successToast(msg: loginResponseModel.message);
    } catch (e) {
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

  register({
    required BuildContext ctx,
  }) async {
    try {
      Map data = {
        "email": registerEmailController.text.trim(),
        "password": registerPasswordController.text.trim(),
        "lastName": registerLastNameController.text.trim(),
        "firstName": registerFirstNameController.text.trim(),
        "address": registerAddressController.text.trim(),
        "phoneNumber": registerPhoneNumberController.text.trim(),
      };

      CustomDialogs.fullLoadingDialog(
          data: "Registering! Please wait...", context: ctx);
      var response = await BaseClient()
          .post(
            ApiConfig.baseUrl,
            ApiConfig.userUrl + ApiConfig.registerUrl,
            data,
            hasTokenHeader: false,
          )
          .catchError(handleError);
      if (response == null) return null;
      var jsonDecodeResponse = jsonDecode(response);

      consolelog(jsonDecodeResponse["message"]);
      hideLoading(ctx);
      navigate(ctx, OtpBody());
      notifyListeners();
      successToast(msg: jsonDecodeResponse["message"]);
    } catch (e) {
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

  registerOtp({
    required BuildContext ctx,
  }) async {
    try {
      Map data = {
        "email": registerEmailController.text.trim(),
        "OTP": pinputController.text.trim(),
      };

      CustomDialogs.fullLoadingDialog(
          data: "Sending Otp! Please wait...", context: ctx);
      var response = await BaseClient()
          .post(
            ApiConfig.baseUrl,
            "${ApiConfig.userUrl}${ApiConfig.registerUrl}/otp/verify",
            data,
            hasTokenHeader: false,
          )
          .catchError(handleError);
      if (response == null) return null;
      loginResponseModel = loginResponseModelFromJson(response);

      AppSharedPreferences.setAuthToken(loginResponseModel.data?.token ?? "");
      AppSharedPreferences.setUserId(
          loginResponseModel.data?.userData?.id ?? "");
      AppSharedPreferences.setRememberMe(true);

      unfocusKeyboard(ctx);
      hideLoading(ctx);
      navigateOffAllNamed(ctx, RouteName.dashboardRouteName);
    } catch (e) {
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

  loginHideShowPass() {
    isHideLoginPassword = !isHideLoginPassword;
    notifyListeners();
  }

  logout({required BuildContext ctx}) {
    AppSharedPreferences.clearCrendentials();
    Provider.of<DrawerProvider>(ctx, listen: false)
        .changeDrawerSelectedIndex(0);
    navigateOffAllNamed(
      ctx,
      RouteName.loginRouteName,
    );

    successToast(msg: "Successfully logged out");
  }
}
