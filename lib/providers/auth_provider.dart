// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_name.dart';
import 'package:gis_flutter_frontend/providers/drawer_provider.dart';
import 'package:provider/provider.dart';

import '../core/app/enums.dart';
import '../core/config/api_config.dart';
import '../core/development/console.dart';
import '../core/routing/route_navigation.dart';
import '../model/login/login_response_model.dart';
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
      Map data = {
        "email": userEmail?.trim(),
        "password": userPassword,
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
