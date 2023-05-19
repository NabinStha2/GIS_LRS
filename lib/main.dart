import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:gis_flutter_frontend/providers/auth_provider.dart';
import 'package:gis_flutter_frontend/providers/drawer_provider.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/providers/map_provider.dart';
import 'package:gis_flutter_frontend/providers/land_transfer_provider.dart';
import 'package:gis_flutter_frontend/providers/user_provider.dart';
import 'package:gis_flutter_frontend/services/geo_location_service.dart';
import 'package:gis_flutter_frontend/services/local_notification_service.dart';
import 'package:gis_flutter_frontend/utils/app_shared_preferences.dart';
import 'package:gis_flutter_frontend/utils/get_swatch_colors.dart';
import 'package:gis_flutter_frontend/utils/global_context_service.dart';
import 'package:provider/provider.dart';

import 'core/app/colors.dart';
import 'core/routing/route_generator.dart';
import 'core/routing/route_name.dart';

Position? currentPosition;

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Future<void> backgroundHandler(RemoteMessage message) async {
  consolelog("message data :: ${message.data.toString()}");
  consolelog("message title :: ${message.notification!.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // currentPosition = await Geolocator.getCurrentPosition(
  //   desiredAccuracy: LocationAccuracy.high,
  // );
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    consolelog('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    consolelog('User granted provisional permission');
  } else {
    consolelog('User declined or has not accepted permission');
  }

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      consolelog("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        consolelog("New Notification");
        // if (message.data['_id'] != null) {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => DemoScreen(
        //         id: message.data['_id'],
        //       ),
        //     ),
        //   );
        // }
      }
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    consolelog('Got a message whilst in the foreground!');
    consolelog('Message data: ${message.data}');

    if (message.notification != null) {
      consolelog(
          'Message also contained a notification: ${message.notification?.title}');
    }
    LocalNotificationService.createanddisplaynotification(message);
    // setState(() {
    //   pushNotificationModel = PushNotificationModel(
    //     body: message.notification?.body,
    //     title: message.notification?.title,
    //   );
    // });
  });

  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      consolelog("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        consolelog(message.notification!.title ?? "");
        consolelog(message.notification!.body ?? "");
        consolelog("message.data ${message.data['_id']}");
        // setState(() {
        //   pushNotificationModel = PushNotificationModel(
        //     body: message.notification?.body,
        //     title: message.notification?.title,
        //   );
        // });
      }
    },
  );

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
        ChangeNotifierProvider<LandTransferProvider>(
            create: (_) => LandTransferProvider()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalContextService.globalContext,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: RouteName.splashRouteName,
        debugShowCheckedModeBanner: false,
        title: 'GIS LRS',
        // theme: ThemeData(
        //   // useMaterial3: true,
        //   primarySwatch: createMaterialColor(AppColors.kPrimaryColor2),
        //   // primaryColor: AppColors.kPrimaryColor2,
        //   // primaryColorLight: AppColors.kPrimaryColor2,
        //   appBarTheme: const AppBarTheme(
        //     systemOverlayStyle: SystemUiOverlayStyle(
        //       statusBarColor: AppColors.kBrandPrimaryColor,
        //       statusBarBrightness: Brightness.light,
        //     ),
        //     backgroundColor: Colors.white,
        //     shadowColor: Colors.transparent,
        //     surfaceTintColor: Colors.white,
        //     elevation: 0,
        //   ),
        //   brightness: Theme.of(context).brightness,
        //   disabledColor: Colors.grey,
        //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        //   pageTransitionsTheme: const PageTransitionsTheme(builders: {
        //     TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        //     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //   }),
        //   textButtonTheme: TextButtonThemeData(
        //     style: TextButton.styleFrom(
        //       elevation: 0,
        //       foregroundColor: AppColors.kPrimaryColor2,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       disabledBackgroundColor: Colors.grey.shade400,
        //       disabledIconColor: Colors.grey.shade300,
        //       disabledForegroundColor: Colors.grey.shade300,
        //       shadowColor: Colors.transparent,
        //       backgroundColor: AppColors.kPrimaryColor2,
        //     ),
        //   ),
        //   colorScheme: const ColorScheme.light(
        //     primary: AppColors.kPrimaryColor2,
        //     secondary: AppColors.kPrimaryColor2,
        //     background: Colors.white,
        //     error: Colors.red,
        //   ),
        //   splashColor: AppColors.kPrimaryColor2,
        //   highlightColor: AppColors.kPrimaryColor2.withOpacity(0.5),
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: AppColors.kPrimaryColor2,
        //       elevation: 0,
        //       foregroundColor: AppColors.kPrimaryColor2,
        //       shadowColor: Colors.transparent,
        //       disabledBackgroundColor: Colors.grey.shade400,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        // ),
        // ),
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.kBrandPrimaryColor,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.white,
            elevation: 0,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
          ),
          tabBarTheme: TabBarTheme(
            labelStyle: TextStyle(
              color: AppColors.kNeutral800Color,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
              fontSize: 18,
            ),
            unselectedLabelStyle: TextStyle(
              color: AppColors.kNeutral800Color,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Outfit',
            ),
            overlayColor:
                MaterialStateProperty.all(AppColors.kLightPrimaryColor),
            indicatorColor: AppColors.kBrandPrimaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: AppColors.kNeutral800Color,
            labelColor: AppColors.kBrandPrimaryColor,
          ),
          primaryColorLight: AppColors.kBrandPrimaryColor,
          primarySwatch: MaterialColor(
              0xff0D0D0D, getSwatchColor(const Color(0xff0D0D0D))),
          primaryColor: AppColors.kBrandPrimaryColor,
          colorScheme: ColorScheme.light(
            outline: AppColors.kSecondaryBorderColor,
            primary: AppColors.kBrandPrimaryColor,
            secondary: AppColors.kBrandPrimaryColor,
            // primarySwatch: MaterialColor(
            //     0xff09BE8B, getSwatchColor(const Color(0xff09BE8B))),
            background: Colors.white,
            error: Colors.red,
          ),
          drawerTheme: const DrawerThemeData(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            endShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          dialogBackgroundColor: Colors.transparent,
          fontFamily: "Outfit",
          brightness: Theme.of(context).brightness,
          disabledColor: Colors.grey.shade400,
          scaffoldBackgroundColor: AppColors.kScaffoldBackgroundColor,
          splashColor: AppColors.kLightPrimaryColor,
          highlightColor: AppColors.kBrandPrimaryColor.withOpacity(0.5),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              elevation: 0,
              foregroundColor: AppColors.kBrandPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Colors.grey.shade400,
              disabledIconColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade300,
              shadowColor: Colors.transparent,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kBrandPrimaryColor,
              elevation: 0,
              foregroundColor: AppColors.kBrandPrimaryColor,
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
