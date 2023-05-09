// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/model/transfer_land/individual_land_transfer_model.dart';
import 'package:gis_flutter_frontend/model/transfer_land/land_transfer_response_model.dart';
import 'package:gis_flutter_frontend/services/base_client_controller.dart';

import '../core/app/enums.dart';
import '../core/config/api_config.dart';
import '../core/development/console.dart';
import '../model/transfer_land/land_transfer_request_model.dart';
import '../services/api_exceptions.dart';
import '../services/base_client.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/custom_toasts.dart';
import '../utils/get_query.dart';
import '../widgets/custom_dialogs.dart';

class LandTransferProvider extends ChangeNotifier with BaseController {
  bool isLoading = false;

  final GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  final TextEditingController transactionAmt = TextEditingController();
  final TextEditingController sellerBankAcc = TextEditingController();
  final TextEditingController buyerBankAcc = TextEditingController();
  final TextEditingController billToken = TextEditingController();

  String? addLandForTransferMessage;

  List<LandTransferDataResult>? paginatedAllSearchLandTransferResult =
      <LandTransferDataResult>[];
  int paginatedAllSearchLandTransferResultPageNumber = 0;
  int paginatedAllSearchLandTransferResultCount = 0;
  int paginatedAllSearchLandTransferResultTotalPages = 0;
  String? getAllSearchLandTransferMsg;

  LandTransferDataResult? individualLandTransferResult =
      LandTransferDataResult();
  String? getIndividualLandTransferMsg;

  String? addPaymentVoucherFormMsg;

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

  clearPaginatedAllSearchLandTransferValue() {
    paginatedAllSearchLandTransferResult?.clear();
    paginatedAllSearchLandTransferResultCount = 0;
    paginatedAllSearchLandTransferResultPageNumber = 0;
    paginatedAllSearchLandTransferResultTotalPages = 0;
    getAllSearchLandTransferMsg = null;
  }

  getAllSearchLandTransfer({
    required BuildContext context,
    LandTransferRequestModel? landTransferRequestModel,
  }) async {
    try {
      isLoading = true;
      paginatedAllSearchLandTransferResultPageNumber =
          landTransferRequestModel?.page ?? 1;
      if (landTransferRequestModel?.page == 1) {
        paginatedAllSearchLandTransferResultPageNumber = 1;
        paginatedAllSearchLandTransferResult?.clear();
        notifyListeners();
      }
      consolelog(landTransferRequestModel);
      var response = await BaseClient()
          .get(
            ApiConfig.baseUrl,
            "${ApiConfig.landTransferUrl}/${AppSharedPreferences.getUserId}${getQuery(landTransferRequestModel, search: landTransferRequestModel?.search)}",
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      var decodedJson = landTransferResponseModelFromJson(response);
      paginatedAllSearchLandTransferResultCount = decodedJson.data?.count ?? 0;
      paginatedAllSearchLandTransferResultPageNumber =
          decodedJson.data?.currentPageNumber ?? 0;
      paginatedAllSearchLandTransferResultTotalPages =
          decodedJson.data?.totalPages ?? 0;
      paginatedAllSearchLandTransferResult
          ?.addAll(decodedJson.data?.results ?? []);

      isLoading = false;
      getAllSearchLandTransferMsg = null;
      notifyListeners();
    } on AppException catch (err) {
      isLoading = false;
      getAllSearchLandTransferMsg = err.message.toString();
      logger(err.toString(), loggerType: LoggerType.error);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      getAllSearchLandTransferMsg = e.toString();
      notifyListeners();
      consolelog(e.toString());
    }
  }

  clearIndividualLandTransferValue() {
    individualLandTransferResult = LandTransferDataResult();
    getIndividualLandTransferMsg = null;
  }

  getIndividualLandTransfer({
    required BuildContext context,
    LandTransferRequestModel? landTransferRequestModel,
  }) async {
    try {
      isLoading = true;

      var response = await BaseClient()
          .get(
            ApiConfig.baseUrl,
            "${ApiConfig.landTransferUrl}/individual/${landTransferRequestModel?.landTransferId}",
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      var decodedJson = individualLandTransferResponseModelFromJson(response);
      individualLandTransferResult =
          decodedJson.data ?? LandTransferDataResult();

      isLoading = false;
      getIndividualLandTransferMsg = null;
      notifyListeners();
    } on AppException catch (err) {
      isLoading = false;
      getIndividualLandTransferMsg = err.message.toString();
      logger(err.toString(), loggerType: LoggerType.error);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      getIndividualLandTransferMsg = e.toString();
      notifyListeners();
      consolelog(e.toString());
    }
  }

  addPaymentVoucherFormLandForTransfer({
    required BuildContext context,
    required File file,
    LandTransferRequestModel? landTransferRequestModel,
  }) async {
    try {
      isLoading = true;
      // CustomDialogs.fullLoadingDialog(
      //     data: "Adding payment voucher form for land transfer, Please wait...",
      //     context: context);
      var response = await BaseClient()
          .postWithImage(
            ApiConfig.baseUrl,
            "${ApiConfig.landTransferUrl}/${landTransferRequestModel?.landTransferId}/payment-voucher-form",
            method: "PATCH",
            imageKey: "voucherFormImage",
            imgFiles: [file],
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      isLoading = false;
      // hideLoading(context);
      successToast(msg: "Payment voucher form for land transfer successfully.");
      notifyListeners();
    } on AppException catch (err) {
      isLoading = false;
      addPaymentVoucherFormMsg = err.message.toString();
      logger(err.toString(), loggerType: LoggerType.error);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      addPaymentVoucherFormMsg = e.toString();
      notifyListeners();
      consolelog(e.toString());
    }
  }

  addPaymentFormLandForTransfer({
    required BuildContext context,
    LandTransferRequestModel? landTransferRequestModel,
  }) async {
    try {
      isLoading = true;
      CustomDialogs.fullLoadingDialog(
          data: "Adding payment form for land transfer, Please wait...",
          context: context);
      var response = await BaseClient()
          .patch(
            ApiConfig.baseUrl,
            "${ApiConfig.landTransferUrl}/${landTransferRequestModel?.landTransferId}",
            {
              "billToken": billToken.text.trim(),
              "transactionAmt": transactionAmt.text.trim(),
              "sellerBankAcc": sellerBankAcc.text.trim(),
              "buyerBankAcc": buyerBankAcc.text.trim(),
            },
            hasTokenHeader: true,
          )
          .catchError(handleError);
      if (response == null) return false;
      isLoading = false;
      hideLoading(context);
      successToast(msg: "Payment form for land transfer added successfully.");
      getIndividualLandTransfer(
          context: context,
          landTransferRequestModel: LandTransferRequestModel(
            landTransferId: landTransferRequestModel?.landTransferId,
          ));
      notifyListeners();
    } on AppException catch (err) {
      isLoading = false;
      addPaymentVoucherFormMsg = err.message.toString();
      logger(err.toString(), loggerType: LoggerType.error);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      addPaymentVoucherFormMsg = e.toString();
      notifyListeners();
      consolelog(e.toString());
    }
  }
}
