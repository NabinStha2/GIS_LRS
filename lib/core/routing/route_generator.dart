import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_name.dart';
import 'package:gis_flutter_frontend/screens/add_land.dart';
import 'package:gis_flutter_frontend/screens/dashboard_page.dart';
import 'package:gis_flutter_frontend/screens/land_sale_details_screen.dart';
import 'package:gis_flutter_frontend/screens/land_screen.dart';
import 'package:gis_flutter_frontend/screens/land_transfer_screen.dart';
import 'package:gis_flutter_frontend/screens/login_page.dart';
import 'package:gis_flutter_frontend/screens/map_page.dart';
import 'package:gis_flutter_frontend/screens/payment_form.dart';
import 'package:gis_flutter_frontend/screens/register/register_screen.dart';
import 'package:gis_flutter_frontend/screens/search_land.dart';
import 'package:gis_flutter_frontend/screens/search_land_sale_screen.dart';

import '../../screens/dashboard_land_requested_screen.dart';
import '../../screens/edit_profile_page.dart';
import '../../screens/land_details_screen.dart';
import '../../screens/land_sale_screen.dart';
import '../../screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // case RouteName.rootRoute:
      //   return MaterialPageRoute(builder: (_) => MainScreen());

      case RouteName.dashboardRouteName:
        return MaterialPageRoute(builder: (_) => const DashboardPage());

      case RouteName.loginRouteName:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteName.editProfileRouteName:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());

      case RouteName.addLandRouteName:
        return MaterialPageRoute(builder: (_) => const AddLandScreen());

      case RouteName.landRouteName:
        return MaterialPageRoute(builder: (_) => const LandScreen());

      case RouteName.mapPageRouteName:
        return MaterialPageRoute(builder: (_) => const MapPage());

      case RouteName.searchLandRouteName:
        return MaterialPageRoute(builder: (_) => const SearchLandScreen());

      case RouteName.landDetailsRouteName:
        return MaterialPageRoute(builder: (_) => const LandDetailsScreen());

      case RouteName.landSaleRouteName:
        return MaterialPageRoute(builder: (_) => const LandSaleScreen());

      case RouteName.searchLandSaleRouteName:
        return MaterialPageRoute(builder: (_) => const SearchLandSaleScreen());

      case RouteName.landSaleDetailsRouteName:
        return MaterialPageRoute(builder: (_) => const LandSaleDetailsScreen());

      case RouteName.dashboardLandRequestedToBuyRouteName:
        return MaterialPageRoute(
            builder: (_) => const DashboardLandRequestedScreen());

      case RouteName.landTransferringRouteName:
        return MaterialPageRoute(builder: (_) => const LandTransferScreen());

      case RouteName.paymentFormRouteName:
        return MaterialPageRoute(builder: (_) => const PaymentFormScreen());

      case RouteName.registerRouteName:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteName.splashRouteName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
    return null;
  }
}





// import 'package:gis_flutter_frontend/core/routing/route_name.dart';
// import 'package:gis_flutter_frontend/screens/add_plygon.dart';
// import 'package:gis_flutter_frontend/screens/dashboard_page.dart';
// import 'package:gis_flutter_frontend/screens/login_page.dart';

// import 'package:go_router/go_router.dart';

// import '../../screens/edit_profile_page.dart';
// import '../../screens/map_page.dart';
// import '../../utils/global_context_service.dart';

// class RouteGenerator {
//   static final GoRouter goRouter = GoRouter(
//     debugLogDiagnostics: true,
//     initialLocation: "/",
//     navigatorKey: GlobalContextService.globalContext,
//     routes: [
//       // ShellRoute(
//       //   navigatorKey: GlobalContextService.shellNavigatorKey,
//       //   builder: (context, state, child) {
//       //     return ScaffoldWithNavBar(child: child);
//       //   },
//       //   routes: [
//           GoRoute(
//             name: RouteName.rootRoute,
//             path: "/",
//             builder: (context, state) => const DashboardPage(),
//             routes: [
//               // GoRoute(
//               //   name: RouteName.dashboardRouteName,
//               //   path: RouteName.dashboardRoute,
//               //   builder: (context, state) => const DashboardPage(),
//               //   routes: [
//               GoRoute(
//                 name: RouteName.editProfileRouteName,
//                 path: RouteName.editProfileRoute,
//                 builder: (context, state) => const EditProfilePage(),
//               ),
//               // ],
//               // ),
//             ],
//           ),
//           GoRoute(
//             name: RouteName.mapPageRouteName,
//             path: RouteName.mapPageRoute,
//             builder: (context, state) => const MapPage(),
//           ),
//           GoRoute(
//             name: RouteName.addPolygonRouteName,
//             path: RouteName.addPolygonRoute,
//             builder: (context, state) => const AddPolygon(),
//           ),
//       //   ],
//       // ),
//       GoRoute(
//         name: RouteName.loginRouteName,
//         path: RouteName.loginRoute,
//         builder: (context, state) => const LoginPage(),
//       ),
//     ],
//   );
// }

// // class ScaffoldWithNavBar extends StatefulWidget {
// //   const ScaffoldWithNavBar({super.key, required this.child});

// //   final Widget child;

// //   @override
// //   State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
// // }

// // class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
// //   int _currentIndex = 0;
// //   int _hoverCurrentInd = -1;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: Row(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(left: 16),
// //               child: Image.network(
// //                 "https://png.pngtree.com/element_pic/00/16/09/2057e0eecf792fb.jpg",
// //                 width: 28,
// //               ),
// //             ),
// //           ],
// //         ),
// //         title: Row(
// //           children: [
// //             CustomText.ourText(
// //               "GIS LRS",
// //               color: lightGrey,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //             // const Spacer(),
// //             // Row(
// //             //   children: [
// //             //     Container(
// //             //       decoration: BoxDecoration(
// //             //           border: Border.all(
// //             //             color: Colors.grey.withOpacity(0.7),
// //             //           ),
// //             //           borderRadius: BorderRadius.circular(8)),
// //             //       width: 200,
// //             //       height: 50,
// //             //       child: CustomTextFormField(
// //             //         controller: searchController,
// //             //         hintText: "Search by Parcel id or location..",
// //             //       ),
// //             //     ),
// //             //     IconButton(
// //             //       icon: Icon(
// //             //         Icons.search,
// //             //         color: dark.withOpacity(.7),
// //             //       ),
// //             //       splashRadius: 10,
// //             //       onPressed: () {},
// //             //     ),
// //             //   ],
// //             // ),
// //             // Stack(
// //             //   children: [
// //             //     IconButton(
// //             //         icon: Icon(
// //             //           Icons.notifications,
// //             //           color: dark.withOpacity(.7),
// //             //         ),
// //             //         splashRadius: 10,
// //             //         onPressed: () {}),
// //             //     Positioned(
// //             //       top: 7,
// //             //       right: 7,
// //             //       child: Container(
// //             //         width: 12,
// //             //         height: 12,
// //             //         padding: const EdgeInsets.all(4),
// //             //         decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(30), border: Border.all(color: light, width: 2)),
// //             //       ),
// //             //     )
// //             //   ],
// //             // ),
// //             // Container(
// //             //   width: 1,
// //             //   height: 22,
// //             //   color: lightGrey,
// //             // ),
// //             // const SizedBox(
// //             //   width: 24,
// //             // ),
// //             Consumer<AuthProvider>(
// //               builder: (context, _, child) => MouseRegion(
// //                 cursor: SystemMouseCursors.click,
// //                 child: GestureDetector(
// //                   onTap: () {
// //                     logger(AppSharedPreferences.getUserId);
// //                     _.isLoggedIn ? _.logout(ctx: context) : navigateNamed(context, RouteName.loginRouteName);
// //                   },
// //                   child: CustomText.ourText(
// //                     _.isLoggedIn ? "Logout" : "Login",
// //                     color: lightGrey,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(
// //               width: 16,
// //             ),
// //           ],
// //         ),
// //         iconTheme: IconThemeData(color: dark),
// //         elevation: 0,
// //         backgroundColor: Colors.transparent,
// //       ),
// //       body: Row(
// //         children: [
// //           Expanded(
// //             flex: 3,
// //             child: Column(
// //               children: [
// //                 MouseRegion(
// //                   cursor: SystemMouseCursors.click,
// //                   onExit: (_) {
// //                     setState(() {
// //                       _hoverCurrentInd = -1;
// //                     });
// //                   },
// //                   onHover: (_) {
// //                     // consolelog(_.position);
// //                     setState(() {
// //                       _hoverCurrentInd = 0;
// //                     });
// //                   },
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         _currentIndex = 0;
// //                         navigateOffAllNamed(context, RouteName.rootRoute);
// //                       });
// //                     },
// //                     child: Container(
// //                       margin: const EdgeInsets.all(12),
// //                       width: appWidth(context),
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: _hoverCurrentInd == 0
// //                             ? Colors.blue[100]
// //                             : _currentIndex == 0
// //                                 ? Colors.lightBlue
// //                                 : Colors.transparent,
// //                         border: Border.all(
// //                           color: Colors.blue.withOpacity(0.1),
// //                         ),
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       child: CustomText.ourText(
// //                         "Dashboard",
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w500,
// //                         color: _currentIndex == 0 ? Colors.white : Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 vSizedBox1,
// //                 MouseRegion(
// //                   cursor: SystemMouseCursors.click,
// //                   onExit: (_) {
// //                     setState(() {
// //                       _hoverCurrentInd = -1;
// //                     });
// //                   },
// //                   onHover: (_) {
// //                     // consolelog(_.position);
// //                     setState(() {
// //                       _hoverCurrentInd = 1;
// //                     });
// //                   },
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         _currentIndex = 1;
// //                         navigateOffAllNamed(context, RouteName.mapPageRouteName);
// //                       });
// //                     },
// //                     child: Container(
// //                       margin: const EdgeInsets.all(12),
// //                       width: appWidth(context),
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: _hoverCurrentInd == 1
// //                             ? Colors.blue[100]
// //                             : _currentIndex == 1
// //                                 ? Colors.lightBlue
// //                                 : Colors.transparent,
// //                         border: Border.all(
// //                           color: Colors.blue.withOpacity(0.1),
// //                         ),
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       child: CustomText.ourText(
// //                         "Map",
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w500,
// //                         color: _currentIndex == 1 ? Colors.white : Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 vSizedBox1,
// //                 MouseRegion(
// //                   cursor: SystemMouseCursors.click,
// //                   onExit: (_) {
// //                     setState(() {
// //                       _hoverCurrentInd = -1;
// //                     });
// //                   },
// //                   onHover: (_) {
// //                     // consolelog(_.position);
// //                     setState(() {
// //                       _hoverCurrentInd = 2;
// //                     });
// //                   },
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         _currentIndex = 2;
// //                         navigateOffAllNamed(context, RouteName.addPolygonRouteName);
// //                       });
// //                     },
// //                     child: Container(
// //                       margin: const EdgeInsets.all(12),
// //                       width: appWidth(context),
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: _hoverCurrentInd == 2
// //                             ? Colors.blue[100]
// //                             : _currentIndex == 2
// //                                 ? Colors.lightBlue
// //                                 : Colors.transparent,
// //                         border: Border.all(
// //                           color: Colors.blue.withOpacity(0.1),
// //                         ),
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       child: CustomText.ourText(
// //                         "Add Polygon",
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w500,
// //                         color: _currentIndex == 2 ? Colors.white : Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(flex: 6, child: widget.child),
// //         ],
// //       ),
// //     );
// //   }
// // }
