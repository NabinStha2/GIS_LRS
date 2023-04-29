import 'package:flutter/cupertino.dart';
import 'package:gis_flutter_frontend/utils/custom_toasts.dart';

import '../core/development/console.dart';
import '../core/routing/route_navigation.dart';
import '../utils/global_context_service.dart';
import '../widgets/custom_dialogs.dart';
import 'api_exceptions.dart';

mixin BaseController {
  customApiExceptionHandleDialog(
      {required String? message, required BuildContext ctx}) {
    CustomDialogs.confirmDialog(ctx, onOk: () {
      back(ctx);
    });
  }

  void handleError(error) {
    consolelog("HandleError: $error");
    BuildContext globalContext =
        GlobalContextService.globalContext.currentContext!;
    if (isNavigatorCanPop(globalContext)) {
      hideLoading(globalContext);
    }
    // Fluttertoast.cancel();
    if (error is BadRequestException) {
      // var message = error.message;
      // customApiExceptionHandleDialog(message: message, ctx: globalContext);
      errorToast(msg: error.message ?? "");
      throw error;
    } else if (error is FetchDataException) {
      // var message = error.message;
      // customApiExceptionHandleDialog(message: message, ctx: globalContext);
      errorToast(msg: error.message ?? "");
      throw error;
    } else if (error is UnAuthorizedException) {
      // var message = error.message;
      // customApiExceptionHandleDialog(message: message, ctx: globalContext);
      errorToast(msg: error.message ?? "");
      throw error;
    } else if (error is ApiNotRespondingException) {
      // var message = error.message;
      // customApiExceptionHandleDialog(message: message, ctx: globalContext);
      errorToast(msg: error.message ?? "");
      throw error;
    } else {
      consolelog("something went wrong");
      errorToast(msg: "something went wrong");
      throw error;
      // CustomDialogs.confirmDialog(
      //   navigat,
      //   onOk: () {
      //     back(ctx);
      //   },
      //   title: 'Something went wrong, try again later',
      // );
    }
  }

  hideLoading(BuildContext ctx) {
    back(ctx);
  }

  bool isNavigatorCanPop(BuildContext ctx) {
    return Navigator.canPop(ctx);
  }
}
