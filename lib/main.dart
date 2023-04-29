import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gis_flutter_frontend/providers/auth_provider.dart';
import 'package:gis_flutter_frontend/providers/drawer_provider.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/providers/map_provider.dart';
import 'package:gis_flutter_frontend/providers/user_provider.dart';
import 'package:gis_flutter_frontend/services/geo_location_service.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';
import 'package:gis_flutter_frontend/utils/global_context_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/app/colors.dart';
import 'core/routing/route_generator.dart';
import 'core/routing/route_name.dart';

Position? currentPosition;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // currentPosition = await Geolocator.getCurrentPosition(
  //   desiredAccuracy: LocationAccuracy.high,
  // );

  await GeoLocationService.determinePosition();

  await AppSharedPreferences.sharedPrefInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // logger("rememberme :: ${AppSharedPreferences.getRememberMe}");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapProvider>(create: (_) => MapProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<LandProvider>(create: (_) => LandProvider()),
        ChangeNotifierProvider<DrawerProvider>(create: (_) => DrawerProvider()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalContextService.globalContext,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AppSharedPreferences.getRememberMe
            ? RouteName.dashboardRouteName
            : RouteName.loginRouteName,
        debugShowCheckedModeBanner: false,
        title: 'GIS LRS',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.kPrimaryColor2,
          primaryColorLight: AppColors.kPrimaryColor2,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.kPrimaryColor2,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.white,
            elevation: 0,
          ),
          brightness: Theme.of(context).brightness,
          disabledColor: Colors.grey,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              elevation: 0,
              foregroundColor: AppColors.kPrimaryColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey.shade400,
              disabledIconColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade300,
              shadowColor: Colors.transparent,
              backgroundColor: AppColors.kPrimaryColor2,
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: AppColors.kPrimaryColor2,
            secondary: AppColors.kPrimaryColor2,
            background: Colors.white,
            error: Colors.red,
          ),
          splashColor: AppColors.kPrimaryColor2,
          highlightColor: AppColors.kPrimaryColor2.withOpacity(0.5),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor2,
              elevation: 0,
              foregroundColor: AppColors.kPrimaryColor2,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
