// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/services/base_client_controller.dart';

import '../core/app/enums.dart';
import '../core/config/api_config.dart';
import '../core/development/console.dart';
import '../model/transfer_land/land_transfer_request_model.dart';
import '../services/api_exceptions.dart';
import '../services/base_client.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/custom_toasts.dart';
import '../widgets/custom_dialogs.dart';

class LandTransferProvider extends ChangeNotifier with BaseController {
  bool isLoading = false;

  String? addLandForTransferMessage;

  addLandForTransfer({
    required BuildContext context,
    LandTransferRequestModel? landTransferRequestModel,
  }) async {
    try {
      isLoading = true;
      CustomDialogs.fullLoadingDialog(
          data: "Adding Land for sale, Please wait...", context: context);
      var userId = AppSharedPreferences.getUserId;
      consolelog(userId);
      var response = await BaseClient()
          .post(
            ApiConfig.baseUrl,
            "${ApiConfig.landTransferUrl}/${landTransferRequestModel?.landSaleId}",
            {},
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      isLoading = false;
      hideLoading(context);
      successToast(msg: "Land for transfer added successfully.");
      notifyListeners();
    } on AppException catch (err) {
      isLoading = false;
      addLandForTransferMessage = err.message.toString();
      logger(err.toString(), loggerType: LoggerType.error);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      addLandForTransferMessage = e.toString();
      notifyListeners();
      consolelog(e.toString());
    }
  }
}
