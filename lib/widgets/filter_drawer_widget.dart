import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/colors.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/utils/unfocus_keyboard.dart';
import 'package:provider/provider.dart';

import '../core/routing/route_navigation.dart';
import '../model/land/land_request_model.dart';
import '../providers/land_provider.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import 'custom_text_form_field.dart';

class FilterDrawerWidget extends StatelessWidget {
  final bool? isFromLandSale;
  const FilterDrawerWidget({
    Key? key,
    this.isFromLandSale = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<LandProvider>(
        builder: (context, _, child) => Container(
          padding: screenPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              vSizedBox2,
              CustomText.ourText(
                "Filter Land",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.kTextPrimaryColor,
              ),
              vSizedBox2,
              CustomText.ourText(
                "City",
                fontSize: 16,
                color: AppColors.kTextPrimaryColor,
              ),
              vSizedBox1,
              CustomTextFormField(
                hintText: "Search land by city...",
                controller: _.filterCityLandController,
                searchString: true,
                textInputAction: TextInputAction.next,
              ),
              vSizedBox2,
              CustomText.ourText(
                "District",
                fontSize: 16,
                color: AppColors.kTextPrimaryColor,
              ),
              vSizedBox1,
              CustomTextFormField(
                hintText: "Search land by district...",
                controller: _.filterDistrictLandController,
                searchString: true,
                textInputAction: TextInputAction.next,
              ),
              vSizedBox2,
              CustomText.ourText(
                "Province",
                fontSize: 16,
                color: AppColors.kTextPrimaryColor,
              ),
              vSizedBox1,
              CustomTextFormField(
                hintText: "Search land by province...",
                controller: _.filterProvinceLandController,
                searchString: true,
                textInputAction: TextInputAction.done,
              ),
              vSizedBox2,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton.elevatedButton(
                      "Clear All",
                      () {
                        _.filterCityLandController.clear();
                        _.filterDistrictLandController.clear();
                        _.filterProvinceLandController.clear();
                      },
                      borderRadius: 8,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      isBorder: true,
                      borderColor: AppColors.kBorderColor,
                      color: AppColors.kPrimaryButtonBackgroundColor,
                      titleColor: Colors.black,
                    ),
                  ),
                  hSizedBox2,
                  Expanded(
                    child: CustomButton.elevatedButton(
                      "Apply",
                      () {
                        unfocusKeyboard(context);
                        isFromLandSale ?? false
                            ? _.getSaleLand(
                                context: context,
                                landRequestModel: LandRequestModel(
                                  search: _.searchLandController.text.trim(),
                                  page: 1,
                                  city: _.filterCityLandController.text.trim(),
                                  district: _.filterDistrictLandController.text
                                      .trim(),
                                  province: _.filterProvinceLandController.text
                                      .trim(),
                                ),
                              )
                            : _.getAllSearchLands(
                                context: context,
                                landRequestModel: LandRequestModel(
                                  page: 1,
                                  search: _.searchLandController.text.trim(),
                                  city: _.filterCityLandController.text.trim(),
                                  district: _.filterDistrictLandController.text
                                      .trim(),
                                  province: _.filterProvinceLandController.text
                                      .trim(),
                                ));
                        back(context);
                      },
                      borderRadius: 8,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
