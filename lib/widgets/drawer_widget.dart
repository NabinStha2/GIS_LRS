import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/providers/auth_provider.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../core/routing/route_name.dart';
import '../providers/drawer_provider.dart';
import '../providers/user_provider.dart';

class DrawerWidget extends StatelessWidget {
  final bool? isFromDetails;
  final GlobalKey<ScaffoldState> scKey;
  const DrawerWidget({
    Key? key,
    this.isFromDetails = false,
    required this.scKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (BuildContext context, _, Widget? child) {
        return Drawer(
          elevation: 0.0,
          width: appWidth(context) * 0.8,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.kBrandPrimaryColor,
                ),
                child: Consumer<UserProvider>(
                  builder: (context, _, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(_.userData.imageFile?.imageUrl ?? ""),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _.userData.name ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _.userData.email ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                tileColor: _.drawerSelectedIndex == 0
                    ? AppColors.kBrandPrimaryColor
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                leading: Icon(
                  Icons.dashboard,
                  color:
                      _.drawerSelectedIndex == 0 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'Dashboard',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 0 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(0);
                  navigateOffAllNamed(context, RouteName.dashboardRouteName);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                tileColor: _.drawerSelectedIndex == 1
                    ? AppColors.kBrandPrimaryColor
                    : null,
                leading: Icon(
                  Icons.map,
                  color:
                      _.drawerSelectedIndex == 1 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'Map',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 1 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(1);
                  navigateOffAllNamed(context, RouteName.mapPageRouteName);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                tileColor: _.drawerSelectedIndex == 2
                    ? AppColors.kBrandPrimaryColor
                    : null,
                leading: Icon(
                  Icons.landscape,
                  color:
                      _.drawerSelectedIndex == 2 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'Lands Owned',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 2 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(2);
                  navigateOffAllNamed(context, RouteName.landRouteName);
                },
              ),
              // ListTile(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(50),
              //   ),
              //   tileColor: _.drawerSelectedIndex == 3
              //       ? AppColors.kBrandPrimaryColor
              //       : null,
              //   leading: Icon(
              //     Icons.search,
              //     color:
              //         _.drawerSelectedIndex == 3 ? Colors.white : Colors.black,
              //   ),
              //   title: CustomText.ourText(
              //     'Search Land',
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //     color:
              //         _.drawerSelectedIndex == 3 ? Colors.white : Colors.black,
              //   ),
              //   onTap: () {
              //     _.changeDrawerSelectedIndex(3);
              //     navigateOffAllNamed(context, RouteName.searchLandRouteName);
              //   },
              // ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                tileColor: _.drawerSelectedIndex == 3
                    ? AppColors.kBrandPrimaryColor
                    : null,
                leading: Icon(
                  Icons.sell,
                  color:
                      _.drawerSelectedIndex == 3 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'My Sell',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 3 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(3);
                  navigateOffAllNamed(context, RouteName.landSaleRouteName);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                tileColor: _.drawerSelectedIndex == 4
                    ? AppColors.kBrandPrimaryColor
                    : null,
                leading: Icon(
                  Icons.search,
                  color:
                      _.drawerSelectedIndex == 4 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'Lands on sale',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 4 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(4);
                  navigateOffAllNamed(
                      context, RouteName.searchLandSaleRouteName);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                tileColor: _.drawerSelectedIndex == 5
                    ? AppColors.kBrandPrimaryColor
                    : null,
                leading: Icon(
                  Icons.transform,
                  color:
                      _.drawerSelectedIndex == 5 ? Colors.white : Colors.black,
                ),
                title: CustomText.ourText(
                  'Title Transfer',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      _.drawerSelectedIndex == 5 ? Colors.white : Colors.black,
                ),
                onTap: () {
                  _.changeDrawerSelectedIndex(5);
                  navigateOffAllNamed(
                      context, RouteName.landTransferringRouteName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: CustomText.ourText(
                  'Logout',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () async {
                  Provider.of<AuthProvider>(context, listen: false)
                      .logout(ctx: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
