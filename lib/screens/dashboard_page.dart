import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/providers/land_provider.dart';
import 'package:gis_flutter_frontend/providers/user_provider.dart';
import 'package:gis_flutter_frontend/screens/dashboard_land_accepted_screen.dart';
import 'package:gis_flutter_frontend/screens/edit_profile_page.dart';
import 'package:gis_flutter_frontend/utils/double_tap_back.dart';
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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton.elevatedButton(
                        "Edit Profile",
                        () {
                          navigate(
                            context,
                            EditProfilePage(
                              userData: _.userData,
                            ),
                          );
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
                              vSizedBox1,
                              CustomText.ourText(
                                _.userData.email ?? "",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              vSizedBox1,
                              CustomText.ourText(
                                _.userData.phoneNumber ?? "",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              vSizedBox1,
                              CustomText.ourText(
                                _.userData.address ?? "",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                      vSizedBox2,
                      Text.rich(
                        TextSpan(
                          text: "Citizenship No. : ",
                          style: TextStyle(
                            color: AppColors.kNeutral800Color,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: _.userData.citizenshipId.toString(),
                              style: TextStyle(
                                color: AppColors.kNeutral600Color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      vSizedBox2,
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
                            const VerticalDivider(
                                color: Colors.grey, width: 12),
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
                      Divider(
                        color: AppColors.kSecondaryTextColor,
                        height: 5,
                      ),
                      vSizedBox2,
                      CustomButton.textButton(
                        "Land Requested   -->",
                        () {
                          navigate(
                              context, const DashboardLandRequestedScreen());
                        },
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        borderRadius: 12,
                        isBorder: true,
                      ),
                      vSizedBox2,
                      CustomButton.textButton(
                        "Land Accepted   -->",
                        () {
                          navigate(
                              context, const DashboardLandAcceptedScreen());
                        },
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        borderRadius: 12,
                        isBorder: true,
                      ),
                      vSizedBox2,
                      CustomButton.textButton(
                        "Land Rejected   -->",
                        () {
                          navigate(
                              context, const DashboardLandRejectedScreen());
                        },
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        borderRadius: 12,
                        isBorder: true,
                      ),
                      vSizedBox1,
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
