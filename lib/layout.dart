import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:gis_flutter_frontend/screens/add_land.dart';
import 'package:gis_flutter_frontend/screens/dashboard_page.dart';
import 'package:gis_flutter_frontend/screens/map_page.dart';
import 'package:gis_flutter_frontend/providers/auth_provider.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';
import 'package:gis_flutter_frontend/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import 'core/routing/route_name.dart';
import 'core/routing/route_navigation.dart';

Color light = const Color(0xFFF7F8FC);
Color lightGrey = const Color(0xFFA4A6B3);
Color dark = const Color(0xFF363740);
Color active = const Color(0xFF3C19C0);

PageController pageController = PageController();
SideMenuController sideMenuCntr = SideMenuController();

GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

class SiteLayout extends StatefulWidget {
  const SiteLayout({super.key});

  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    sideMenuCntr.addListener((p0) {
      pageController.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.network(
                "https://png.pngtree.com/element_pic/00/16/09/2057e0eecf792fb.jpg",
                width: 28,
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            // CustomText.ourText(
            //   "GIS LRS",
            //   color: lightGrey,
            //   fontSize: 20,
            //   fontWeight: FontWeight.bold,
            // ),
            // const Spacer(),
            // Row(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //           border: Border.all(
            //             color: Colors.grey.withOpacity(0.7),
            //           ),
            //           borderRadius: BorderRadius.circular(8)),
            //       width: 200,
            //       height: 50,
            //       child: CustomTextFormField(
            //         controller: searchController,
            //         hintText: "Search by Parcel id or location..",
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(
            //         Icons.search,
            //         color: dark.withOpacity(.7),
            //       ),
            //       splashRadius: 10,
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            // Stack(
            //   children: [
            //     IconButton(
            //         icon: Icon(
            //           Icons.notifications,
            //           color: dark.withOpacity(.7),
            //         ),
            //         splashRadius: 10,
            //         onPressed: () {}),
            //     Positioned(
            //       top: 7,
            //       right: 7,
            //       child: Container(
            //         width: 12,
            //         height: 12,
            //         padding: const EdgeInsets.all(4),
            //         decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(30), border: Border.all(color: light, width: 2)),
            //       ),
            //     )
            //   ],
            // ),
            // Container(
            //   width: 1,
            //   height: 22,
            //   color: lightGrey,
            // ),
            // const SizedBox(
            //   width: 24,
            // ),
            Consumer<AuthProvider>(
              builder: (context, _, child) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    logger(AppSharedPreferences.getUserId);
                    _.isLoggedIn ? _.logout(ctx: context) : navigateNamed(context, RouteName.loginRouteName);
                  },
                  child: CustomText.ourText(
                    _.isLoggedIn ? "Logout" : "Login",
                    color: lightGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: dark),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenuCntr,
            showToggle: true,
            style: SideMenuStyle(
              showTooltip: false,
              displayMode: SideMenuDisplayMode.open,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.network(
                    'https://png.pngtree.com/element_pic/00/16/09/2057e0eecf792fb.jpg',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: (page, _) {
                  sideMenuCntr.changePage(page);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Map',
                onTap: (page, _) {
                  sideMenuCntr.changePage(page);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Add Land',
                onTap: (page, _) {
                  sideMenuCntr.changePage(page);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                DashboardPage(),
                MapPage(),
                AddLandScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
