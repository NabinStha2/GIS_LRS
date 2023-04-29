import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/screens/add_land.dart';
import 'package:gis_flutter_frontend/widgets/custom_button.dart';
import 'package:gis_flutter_frontend/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../core/app/dimensions.dart';
import '../model/land/land_request_model.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/land_card_widget.dart';
import 'dashboard_page.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({super.key});

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getOwnedLands(
          context: context, landRequestModel: LandRequestModel(page: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Land",
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
        child: Consumer<LandProvider>(
          builder: (context, _, child) => Column(
            children: [
              CustomButton.elevatedButton(
                "Add Land",
                () {
                  navigate(context, const AddLandScreen());
                },
              ),
              Expanded(
                child: _.isLoading
                    ? const CustomCircularProgressIndicatorWidget(
                        title: "Loading lands...",
                      )
                    : _.getLandMessage != null
                        ? Center(
                            child: CustomText.ourText(_.getLandMessage,
                                color: Colors.red),
                          )
                        : _.paginatedOwnedLandResult?.isEmpty ?? false
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
                                      _.paginatedOwnedLandResultPageNumber +
                                              1 <=
                                          _.paginatedOwnedLandResultTotalPages) {
                                    _.getOwnedLands(
                                        context: context,
                                        landRequestModel: LandRequestModel(
                                          page:
                                              _.paginatedOwnedLandResultPageNumber +
                                                  1,
                                        ));
                                  }
                                  return true;
                                },
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1), () {});
                                    _.clearPaginatedOwnedLandValue();
                                    _.getOwnedLands(
                                        context: context,
                                        landRequestModel: LandRequestModel(
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
                                          separatorBuilder: (context, index) =>
                                              vSizedBox2,
                                          itemCount: _.paginatedOwnedLandResult
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                LandCardWidget(
                                                  landResult:
                                                      _.paginatedOwnedLandResult?[
                                                          index],
                                                  saleData: _
                                                      .paginatedOwnedLandResult?[
                                                          index]
                                                      .saleData,
                                                  landId: _
                                                      .paginatedOwnedLandResult?[
                                                          index]
                                                      .id,
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _.deleteLand(
                                                        context: context,
                                                        landRequestModel:
                                                            LandRequestModel(
                                                                landId: _
                                                                    .paginatedOwnedLandResult?[
                                                                        index]
                                                                    .id),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.red),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        vSizedBox1,
                                        _.paginatedOwnedLandResultPageNumber <
                                                _.paginatedOwnedLandResultTotalPages
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child:
                                                    const CustomCircularProgressIndicatorWidget(
                                                  title:
                                                      "Loading Land, Please wait...",
                                                ),
                                              )
                                            : Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: CustomText.ourText(
                                                  "No more Land to Load.",
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
    );
  }
}
