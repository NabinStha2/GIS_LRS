// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/model/transfer_land/land_transfer_request_model.dart';
import 'package:gis_flutter_frontend/providers/land_transfer_provider.dart';
import 'package:provider/provider.dart';

import '../core/app/dimensions.dart';
import '../providers/land_provider.dart';
import '../utils/double_tap_back.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/land_card_widget.dart';
import 'dashboard_page.dart';

class LandTransferScreen extends StatefulWidget {
  const LandTransferScreen({super.key});

  @override
  State<LandTransferScreen> createState() => _LandTransferScreenState();
}

class _LandTransferScreenState extends State<LandTransferScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandTransferProvider>(context, listen: false)
          .getAllSearchLandTransfer(
              context: context,
              landTransferRequestModel: LandTransferRequestModel(page: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: CustomText.ourText(
            "Land Transferring",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        drawerEdgeDragWidth: 150,
        drawer: DrawerWidget(
          scKey: scKey,
        ),
        body: Padding(
          padding: screenLeftRightPadding,
          child: Consumer2<LandTransferProvider, LandProvider>(
            builder: (context, _, __, child) => Column(
              children: [
                Expanded(
                  child: _.isLoading
                      ? const CustomCircularProgressIndicatorWidget(
                          title: "Loading lands transfer data...",
                        )
                      : _.getAllSearchLandTransferMsg != null
                          ? Center(
                              child: CustomText.ourText(
                                  _.getAllSearchLandTransferMsg,
                                  color: Colors.red),
                            )
                          : _.paginatedAllSearchLandTransferResult?.isEmpty ??
                                  false
                              ? Center(
                                  child: CustomText.ourText(
                                    "Empty",
                                  ),
                                )
                              : NotificationListener<ScrollUpdateNotification>(
                                  onNotification: (ScrollUpdateNotification
                                      scrollNotification) {
                                    if (scrollNotification.metrics.pixels ==
                                            scrollNotification
                                                .metrics.maxScrollExtent &&
                                        _.paginatedAllSearchLandTransferResultPageNumber +
                                                1 <=
                                            _.paginatedAllSearchLandTransferResultTotalPages) {
                                      _.getAllSearchLandTransfer(
                                          context: context,
                                          landTransferRequestModel:
                                              LandTransferRequestModel(
                                            page:
                                                _.paginatedAllSearchLandTransferResultPageNumber +
                                                    1,
                                          ));
                                    }
                                    return true;
                                  },
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await Future.delayed(
                                          const Duration(seconds: 1), () {});
                                      _.clearPaginatedAllSearchLandTransferValue();
                                      _.getAllSearchLandTransfer(
                                          context: context,
                                          landTransferRequestModel:
                                              LandTransferRequestModel(
                                            page: 1,
                                          ));
                                    },
                                    child: SingleChildScrollView(
                                      key: const PageStorageKey<String>(
                                          "landScreen"),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      child: Column(
                                        children: [
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) => vSizedBox2,
                                            itemCount:
                                                _.paginatedAllSearchLandTransferResult
                                                        ?.length ??
                                                    0,
                                            itemBuilder: (context, index) {
                                              return LandCardWidget(
                                                landTransferId: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .id,
                                                landData: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .landSaleId
                                                    ?.landId,
                                                saleData: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .transerData,
                                                landId: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .landSaleId
                                                    ?.landId
                                                    ?.id,
                                                isFromLandSale: true,
                                                geoJSONLandSaleData: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .landSaleId
                                                    ?.geoJson,
                                                landSaleId: _
                                                    .paginatedAllSearchLandTransferResult?[
                                                        index]
                                                    .landSaleId
                                                    ?.id,
                                                isFromLandTransfer: true,
                                              );
                                            },
                                          ),
                                          vSizedBox1,
                                          _.paginatedAllSearchLandTransferResultPageNumber <
                                                  _.paginatedAllSearchLandTransferResultTotalPages
                                              ? Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child:
                                                      const CustomCircularProgressIndicatorWidget(
                                                    title:
                                                        "Loading Land Transfer data, Please wait...",
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: CustomText.ourText(
                                                    "No more Land Transfer data to Load.",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                          vSizedBox2,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
