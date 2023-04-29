import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_name.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/providers/user_provider.dart';
import 'package:gis_flutter_frontend/screens/dashboard_land_accepted_screen.dart';
import 'package:gis_flutter_frontend/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../model/land/land_request_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_network_image_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer_widget.dart';
import 'dashboard_land_rejected_screen.dart';
import 'dashboard_land_requested_screen.dart';

GlobalKey<ScaffoldState> scKey = GlobalKey<ScaffoldState>();

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getUser(ctx: context);
      Provider.of<LandProvider>(context, listen: false).ownedRequestedSaleLand(
          context: context, landRequestModel: LandRequestModel(page: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText.ourText(
          "Dashboard",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      drawerEdgeDragWidth: 150,
      drawerEnableOpenDragGesture: true,
      drawer: DrawerWidget(
        scKey: scKey,
      ),
      body: Consumer2<UserProvider, LandProvider>(
        builder: (context, _, __, child) => _.isLoading
            ? const CustomCircularProgressIndicatorWidget(
                title: "Loading user profile...",
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton.textButton(
                      "Edit Profile",
                      () {
                        navigateNamed(context, RouteName.editProfileRouteName);
                      },
                    ),
                    vSizedBox2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _.userData.imageFile?.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomNetworkImage(
                                  imageUrl: _.userData.imageFile?.imageUrl,
                                ),
                              )
                            : const SizedBox(
                                height: 100,
                                width: 100,
                                child: Icon(Icons.person),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.ourText(
                              _.userData.name ?? "",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            vSizedBox2,
                            CustomText.ourText(
                              _.userData.email ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            vSizedBox2,
                            CustomText.ourText(
                              _.userData.phoneNumber ?? "",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            vSizedBox2,
                            CustomText.ourText(
                              _.userData.address ?? "",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            vSizedBox2,
                          ],
                        ),
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText.ourText(
                                  "Front Citizenship Document",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                vSizedBox1,
                                CustomNetworkImage(
                                  imageUrl: _.userData.frontCitizenshipFile
                                      ?.frontCitizenshipImage,
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(color: Colors.grey, width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText.ourText(
                                  "Back Citizenship Document",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                vSizedBox1,
                                CustomNetworkImage(
                                  imageUrl: _.userData.backCitizenshipFile
                                      ?.backCitizenshipImage,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    vSizedBox2,
                    const Divider(
                      color: AppColors.kTextSecondaryColor,
                      height: 5,
                    ),
                    vSizedBox2,
                    CustomButton.textButton(
                      "Information on Land Requested To Buy   -->",
                      () {
                        navigate(context, const DashboardLandRequestedScreen());
                      },
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox2,
                    CustomButton.textButton(
                      "Information on Land Accepted To Buy   -->",
                      () {
                        navigate(context, const DashboardLandAcceptedScreen());
                      },
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox2,
                    CustomButton.textButton(
                      "Information on Land Rejected To Buy   -->",
                      () {
                        navigate(context, const DashboardLandRejectedScreen());
                      },
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    vSizedBox1,
                  ],
                ),
              ),
      ),
    );
  }
}
