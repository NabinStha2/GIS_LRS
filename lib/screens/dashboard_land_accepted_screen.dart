import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app/dimensions.dart';
import '../model/land/land_request_model.dart';
import '../providers/land_provider.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_text.dart';
import '../widgets/land_card_widget.dart';

class DashboardLandAcceptedScreen extends StatefulWidget {
  const DashboardLandAcceptedScreen({super.key});

  @override
  State<DashboardLandAcceptedScreen> createState() =>
      DashboardLandAcceptedScreenState();
}

class DashboardLandAcceptedScreenState
    extends State<DashboardLandAcceptedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).ownedAccpetedSaleLand(
          context: context, landRequestModel: LandRequestModel(page: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land Accepted To Buy",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: screenLeftRightPadding,
        child: Consumer<LandProvider>(
          builder: (context, _, child) => Container(
            // constraints: const BoxConstraints(
            //   maxHeight: 350,
            // ),
            child: _.isLoading
                ? const CustomCircularProgressIndicatorWidget(
                    title: "Loading accepted land to buy...",
                  )
                : _.getOwnedSaleLandMessage != null
                    ? Center(
                        child: CustomText.ourText(_.getOwnedSaleLandMessage,
                            color: Colors.red),
                      )
                    : _.paginatedOwnedSaleLandResult.isEmpty
                        ? Center(
                            child: CustomText.ourText(
                              "Empty",
                            ),
                          )
                        : NotificationListener<ScrollUpdateNotification>(
                            onNotification:
                                (ScrollUpdateNotification scrollNotification) {
                              if (scrollNotification.metrics.pixels ==
                                      scrollNotification
                                          .metrics.maxScrollExtent &&
                                  _.paginatedOwnedSaleLandResultPageNumber +
                                          1 <=
                                      _.paginatedOwnedSaleLandResultTotalPages) {
                                _.ownedRequestedSaleLand(
                                  context: context,
                                  landRequestModel: LandRequestModel(
                                    page:
                                        _.paginatedOwnedSaleLandResultPageNumber +
                                            1,
                                  ),
                                );
                              }
                              return true;
                            },
                            child: RefreshIndicator(
                              onRefresh: () async {
                                _.clearPaginatedOwnedSaleLandValue();
                                _.ownedRequestedSaleLand(
                                    context: context,
                                    landRequestModel: LandRequestModel(
                                      page: 1,
                                    ));
                                await Future.delayed(
                                    const Duration(seconds: 1), () {});
                              },
                              child: SingleChildScrollView(
                                key: const PageStorageKey<String>(
                                    "landSaleSearchScreen"),
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          vSizedBox2,
                                      itemCount:
                                          _.paginatedOwnedSaleLandResult.length,
                                      itemBuilder: (context, index) {
                                        return LandCardWidget(
                                          landData: _
                                              .paginatedOwnedSaleLandResult[
                                                  index]
                                              .landId,
                                          saleData: _
                                              .paginatedOwnedSaleLandResult[
                                                  index]
                                              .saleData,
                                          isFromLandSale: true,
                                          landSaleId: _
                                              .paginatedOwnedSaleLandResult[
                                                  index]
                                              .id,
                                          geoJSONLandSaleData: _
                                              .paginatedOwnedSaleLandResult[
                                                  index]
                                              .geoJson,
                                        );
                                      },
                                    ),
                                    vSizedBox1,
                                    _.paginatedOwnedSaleLandResultPageNumber <
                                            _.paginatedOwnedSaleLandResultTotalPages
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child:
                                                const CustomCircularProgressIndicatorWidget(
                                              title:
                                                  "Loading Requested Land, Please wait...",
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: CustomText.ourText(
                                              "No more Requested Land to Load.",
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
        ),
      ),
    );
  }
}
