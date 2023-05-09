// import 'package:flutter/material.dart';
// import 'package:gis_flutter_frontend/providers/land_provider.dart';
// import 'package:gis_flutter_frontend/providers/user_provider.dart';
// import 'package:gis_flutter_frontend/widgets/custom_circular_progress_indicator.dart';
// import 'package:provider/provider.dart';

// import '../core/app/dimensions.dart';
// import '../widgets/custom_network_image_widget.dart';
// import '../widgets/custom_text.dart';

// GlobalKey<ScaffoldState> scKey = GlobalKey<ScaffoldState>();

// class UserVisitProfilePage extends StatefulWidget {
//   final String? userId;
//   const UserVisitProfilePage({super.key, this.userId});

//   @override
//   State<UserVisitProfilePage> createState() => _UserVisitProfilePageState();
// }

// class _UserVisitProfilePageState extends State<UserVisitProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Provider.of<UserProvider>(context, listen: false)
//           .getUser(ctx: context, uId: widget.userId ?? "");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText.ourText(
//           "Profile",
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer2<UserProvider, LandProvider>(
//         builder: (context, _, __, child) => _.isLoading
//             ? const CustomCircularProgressIndicatorWidget(
//                 title: "Loading user profile...",
//               )
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _.userData.imageFile?.imageUrl != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: CustomNetworkImage(
//                                   imageUrl: _.userData.imageFile?.imageUrl,
//                                 ),
//                               )
//                             : const SizedBox(
//                                 height: 100,
//                                 width: 100,
//                                 child: Icon(Icons.person),
//                               ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomText.ourText(
//                               _.userData.name ?? "",
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             vSizedBox2,
//                             CustomText.ourText(
//                               _.userData.email ?? "",
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             vSizedBox2,
//                             CustomText.ourText(
//                               _.userData.phoneNumber ?? "",
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             vSizedBox2,
//                             CustomText.ourText(
//                               _.userData.address ?? "",
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             vSizedBox2,
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
