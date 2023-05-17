part of '../register_screen.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, _, child) => SingleChildScrollView(
          padding: screenLeftRightPadding,
          child: Form(
            key: _.registerUserFormKey,
            child: Column(
              children: [
                vSizedBox2,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "First Name",
                        hintText: "First Name",
                        fullNameString: true,
                        controller: _.registerFirstNameController,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    hSizedBox2,
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Last Name",
                        hintText: "Last Name",
                        fullNameString: true,
                        controller: _.registerLastNameController,
                        validator: (val) => val.toString().isEmptyData()
                            ? "Cannot be empty"
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                CustomTextFormField(
                  labelText: "Email",
                  hintText: "Email",
                  controller: _.registerEmailController,
                  validator: (val) => val.toString().isEmptyData()
                      ? "Cannot be empty"
                      : !RegexConfig.emailRegex.hasMatch(val)
                          ? "Email not valid"
                          : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
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
                  controller: _.registerPasswordController,
                ),
                vSizedBox2,
                CustomTextFormField(
                  labelText: "Phone Number",
                  hintText: "Enter your phone number",
                  onlyNumber: true,
                  controller: _.registerPhoneNumberController,
                  validator: (val) => val.toString().isEmptyData()
                      ? "Cannot be empty"
                      : !(val.toString().isValidPhoneNumber)()
                          ? "Phone Number not valid"
                          : null,
                  textInputType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                CustomTextFormField(
                  labelText: "Address",
                  hintText: "Enter your address",
                  fullNameString: true,
                  controller: _.registerAddressController,
                  validator: (val) =>
                      val.toString().isEmptyData() ? "Cannot be empty" : null,
                  textInputAction: TextInputAction.next,
                ),
                vSizedBox2,
                vSizedBox3,
                CustomButton.elevatedButton("Register", () {
                  if (_.registerUserFormKey.currentState?.validate() ?? false) {
                    unfocusKeyboard(context);
                    _.register(
                      ctx: context,
                    );
                  } else {
                    errorToast(msg: "Invalid field");
                  }
                }),
                vSizedBox2,
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kNeutral600Color,
                    ),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => navigateOffAllNamed(
                                context, RouteName.loginRouteName),
                          text: "Login Now",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: AppColors.kNeutral900Color,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
