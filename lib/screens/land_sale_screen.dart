import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:provider/provider.dart';

import '../model/land/land_request_model.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/land_card_widget.dart';
import 'dashboard_page.dart';

class LandSaleScreen extends StatefulWidget {
  const LandSaleScreen({super.key});

  @override
  State<LandSaleScreen> createState() => _LandSaleScreenState();
}

class _LandSaleScreenState extends State<LandSaleScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getOwnedSaleLand(
        context: context,
        landRequestModel: LandRequestModel(page: 1),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land Sale",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      drawerEdgeDragWidth: 150,
      drawer: DrawerWidget(
        scKey: scKey,
      ),
      body: Consumer<LandProvider>(
        builder: (context, _, child) => _.isLoading
            ? const CustomCircularProgressIndicatorWidget(
                title: "Loading lands for sale...",
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
                                  scrollNotification.metrics.maxScrollExtent &&
                              _.paginatedOwnedSaleLandResultPageNumber + 1 <=
                                  _.paginatedOwnedSaleLandResultTotalPages) {
                            _.getOwnedSaleLand(
                                context: context,
                                landRequestModel: LandRequestModel(
                                  page:
                                      _.paginatedOwnedSaleLandResultPageNumber +
                                          1,
                                ));
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await Future.delayed(
                                const Duration(seconds: 1), () {});
                            _.clearPaginatedSaleLandValue();
                            _.getOwnedSaleLand(
                                context: context,
                                landRequestModel: LandRequestModel(
                                  page: 1,
                                ));
                          },
                          child: SingleChildScrollView(
                            key: const PageStorageKey<String>("landSaleScreen"),
                            padding: screenLeftRightPadding,
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      vSizedBox2,
                                  itemCount:
                                      _.paginatedOwnedSaleLandResult.length,
                                  itemBuilder: (context, index) {
                                    return LandCardWidget(
                                      landData: _
                                          .paginatedOwnedSaleLandResult[index]
                                          .landId,
                                      saleData: _
                                          .paginatedOwnedSaleLandResult[index]
                                          .saleData,
                                      isFromLandSale: true,
                                      landSaleId: _
                                          .paginatedOwnedSaleLandResult[index]
                                          .id,
                                      geoJSONLandSaleData: _
                                          .paginatedOwnedSaleLandResult[index]
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
                                              "Loading Land for sale, Please wait...",
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: CustomText.ourText(
                                          "No more Land for sale to Load.",
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
    );
  }
}
