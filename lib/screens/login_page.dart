import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/colors.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import 'package:gis_flutter_frontend/screens/register/register_screen.dart';
import 'package:gis_flutter_frontend/utils/validation.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';
import 'package:gis_flutter_frontend/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import '../core/config/regex_config.dart';
import '../core/app/dimensions.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, _, child) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
              key: _.loginUserFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  Center(
                    child: CustomText.ourText(
                      "Login to GIS LRS",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kNeutral900Color,
                    ),
                  ),
                  vSizedBox3,
                  vSizedBox1,
                  CustomText.ourText(
                    "Email",
                    fontSize: 18,
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    labelText: "Email",
                    hintText: "Email",
                    controller: _.loginEmailController,
                    validator: (val) => val.toString().isEmptyData()
                        ? "Cannot be empty"
                        : !RegexConfig.emailRegex.hasMatch(val)
                            ? "Email not valid"
                            : null,
                    textInputAction: TextInputAction.next,
                  ),
                  vSizedBox2,
                  CustomText.ourText(
                    "Password",
                    fontSize: 18,
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "********",
                    autoFillHint: const [],
                    labelText: "Password",
                    textInputAction: TextInputAction.next,
                    suffix: IconButton(
                      onPressed: () {
                        _.loginHideShowPass();
                      },
                      splashRadius: 20,
                      icon: _.isHideLoginPassword
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined),
                    ),
                    validator: (val) {
                      if (val.toString().isEmptyData()) {
                        return "emptyText";
                      } else if (val.toString().isPasswordLength()) {
                        return "passwordLengthText";
                      } else {
                        return null;
                      }
                    },
                    obscureText: _.isHideLoginPassword,
                    controller: _.loginPasswordController,
                  ),
                  vSizedBox3,
                  CustomButton.elevatedButton("Login", () {
                    _.login(
                      ctx: context,
                      userEmail: _.loginEmailController.text,
                      userPassword: _.loginPasswordController.text,
                    );
                  }),
                  vSizedBox2,
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kNeutral600Color,
                        ),
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    navigate(context, const RegisterScreen()),
                              text: "Register Now",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kNeutral900Color,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
