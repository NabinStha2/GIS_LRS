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

class SearchLandSaleScreen extends StatefulWidget {
  const SearchLandSaleScreen({super.key});

  @override
  State<SearchLandSaleScreen> createState() => _SearchLandSaleScreenState();
}

class _SearchLandSaleScreenState extends State<SearchLandSaleScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LandProvider>(context, listen: false).getSaleLand(
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
            "Search Land Sale",
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
        endDrawer: const FilterDrawerWidget(
          isFromLandSale: true,
        ),
        endDrawerEnableOpenDragGesture: false,
        body: Consumer<LandProvider>(
          builder: (context, _, child) => Padding(
            padding: screenLeftRightPadding,
            child: Column(
              children: [
                CustomTextFormField(
                  hintText: "Search land sale by parcel Id...",
                  controller: _.searchLandController,
                  suffix: const Icon(Icons.search),
                  onlyNumber: true,
                  isFromSearch: true,
                  textInputType: TextInputType.number,
                  onFieldSubmitted: (val) {
                    _.getSaleLand(
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
                            color: AppColors.kPrimaryButtonBackgroundColor,
                            border: Border.all(
                              color: AppColors.kBorderColor,
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
                          title: "Loading land for sale...",
                        )
                      : _.getSaleLandMessage != null
                          ? Center(
                              child: CustomText.ourText(_.getSaleLandMessage,
                                  color: Colors.red),
                            )
                          : _.paginatedSaleLandResult.isEmpty
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
                                        _.paginatedSaleLandResultPageNumber +
                                                1 <=
                                            _.paginatedSaleLandResultTotalPages) {
                                      _.getSaleLand(
                                        context: context,
                                        landRequestModel: LandRequestModel(
                                          search: _.searchLandController.text
                                              .trim(),
                                          page:
                                              _.paginatedSaleLandResultPageNumber +
                                                  1,
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
                                      _.clearPaginatedSaleLandValue();
                                      _.getSaleLand(
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
                                          "landSaleSearchScreen"),
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
                                            itemCount: _
                                                .paginatedSaleLandResult.length,
                                            itemBuilder: (context, index) {
                                              return LandCardWidget(
                                                landData: _
                                                    .paginatedSaleLandResult[
                                                        index]
                                                    .landId,
                                                saleData: _
                                                    .paginatedSaleLandResult[
                                                        index]
                                                    .saleData,
                                                isFromLandSale: true,
                                                landSaleId: _
                                                    .paginatedSaleLandResult[
                                                        index]
                                                    .id,
                                                geoJSONLandSaleData: _
                                                    .paginatedSaleLandResult[
                                                        index]
                                                    .geoJson,
                                              );
                                            },
                                          ),
                                          vSizedBox1,
                                          _.paginatedSaleLandResultPageNumber <
                                                  _.paginatedSaleLandResultTotalPages
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
