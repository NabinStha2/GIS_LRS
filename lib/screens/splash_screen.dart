import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../core/app/medias.dart';
import '../core/routing/route_name.dart';
import '../utils/app_shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 2),
        () => AppSharedPreferences.getRememberMe
            ? navigateNamed(context, RouteName.dashboardRouteName)
            : navigateNamed(context, RouteName.loginRouteName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBrandPrimaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.kBrandPrimaryColor,
        ),
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                kLogoIcon,
                width: appWidth(context) * 0.5,
                color: Colors.white,
              ),
            ),
            vSizedBox1,
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1,
            ),
            vSizedBox3,
          ],
        ),
      ),
    );
  }
}
