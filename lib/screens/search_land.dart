import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import '../core/app/colors.dart';
import '../model/land/land_request_model.dart';
import '../providers/land_provider.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/filter_drawer_widget.dart';
import '../widgets/land_card_widget.dart';
import 'dashboard_page.dart';

class SearchLandScreen extends StatefulWidget {
  const SearchLandScreen({super.key});

  @override
  State<SearchLandScreen> createState() => _SearchLandScreenState();
}

class _SearchLandScreenState extends State<SearchLandScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getAllSearchLands(
          context: context,
          landRequestModel: LandRequestModel(
            page: 1,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomText.ourText(
            "Search Land",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          actions: <Widget>[Container()],
        ),
        drawerEdgeDragWidth: 150,
        key: _key,
        drawer: DrawerWidget(
          scKey: scKey,
        ),
        endDrawer: const FilterDrawerWidget(),
        endDrawerEnableOpenDragGesture: false,
        body: Consumer<LandProvider>(
          builder: (context, _, child) => Padding(
            padding: screenLeftRightPadding,
            child: Column(
              children: [
                CustomTextFormField(
                  hintText: "Search land by parcel Id...",
                  controller: _.searchLandController,
                  suffix: const Icon(Icons.search),
                  onlyNumber: true,
                  isFromSearch: true,
                  textInputType: TextInputType.number,
                  onFieldSubmitted: (val) {
                    _.getAllSearchLands(
                        context: context,
                        landRequestModel: LandRequestModel(
                          page: 1,
                          search: val.trim(),
                          city: _.filterCityLandController.text.trim(),
                          district: _.filterDistrictLandController.text.trim(),
                          province: _.filterProvinceLandController.text.trim(),
                        ));
                  },
                ),
                vSizedBox0,
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _key.currentState?.openEndDrawer();
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.kBrandPrimaryColor,
                            border: Border.all(
                              color: AppColors.kSecondaryBorderColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText.ourText(
                                "Filter By",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              hSizedBox1,
                              const Icon(Icons.filter_alt),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox0,
                Expanded(
                  child: _.isLoading
                      ? const CustomCircularProgressIndicatorWidget(
                          title: "Loading lands...",
                        )
                      : _.getAllSearchLandMessage != null
                          ? Center(
                              child: CustomText.ourText(
                                  _.getAllSearchLandMessage,
                                  color: Colors.red),
                            )
                          : _.paginatedAllSearchLandResult?.isEmpty ?? false
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
                                        _.paginatedAllSearchLandResultPageNumber +
                                                1 <=
                                            _.paginatedAllSearchLandResultTotalPages) {
                                      _.getAllSearchLands(
                                        context: context,
                                        landRequestModel: LandRequestModel(
                                          page:
                                              _.paginatedAllSearchLandResultPageNumber +
                                                  1,
                                          search: _.searchLandController.text
                                              .trim(),
                                          city: _.filterCityLandController.text
                                              .trim(),
                                          district: _
                                              .filterDistrictLandController.text
                                              .trim(),
                                          province: _
                                              .filterProvinceLandController.text
                                              .trim(),
                                        ),
                                      );
                                    }
                                    return true;
                                  },
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      _.clearPaginatedAllSearchLandValue();
                                      _.getAllSearchLands(
                                          context: context,
                                          landRequestModel: LandRequestModel(
                                            page: 1,
                                            search: _.searchLandController.text
                                                .trim(),
                                            city: _
                                                .filterCityLandController.text
                                                .trim(),
                                            district: _
                                                .filterDistrictLandController
                                                .text
                                                .trim(),
                                            province: _
                                                .filterProvinceLandController
                                                .text
                                                .trim(),
                                          ));
                                      await Future.delayed(
                                          const Duration(seconds: 1), () {});
                                    },
                                    child: SingleChildScrollView(
                                      key: const PageStorageKey<String>(
                                          "landSearchScreen"),
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
                                                _.paginatedAllSearchLandResult
                                                        ?.length ??
                                                    0,
                                            itemBuilder: (context, index) {
                                              return LandCardWidget(
                                                landResult:
                                                    _.paginatedAllSearchLandResult?[
                                                        index],
                                                saleData: _
                                                    .paginatedAllSearchLandResult?[
                                                        index]
                                                    .saleData,
                                                landId: _
                                                    .paginatedAllSearchLandResult?[
                                                        index]
                                                    .id,
                                              );
                                            },
                                          ),
                                          vSizedBox1,
                                          _.paginatedAllSearchLandResultPageNumber <
                                                  _.paginatedAllSearchLandResultTotalPages
                                              ? Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child:
                                                      const CustomCircularProgressIndicatorWidget(
                                                    title:
                                                        "Loading Land, Please wait...",
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 15),
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
        ));
  }
}
