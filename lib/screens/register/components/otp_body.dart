part of '../register_screen.dart';

class OtpBody extends StatelessWidget {
  OtpBody({super.key});

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    final fillColor = Color.fromRGBO(243, 246, 249, 0);
    final borderColor = Color.fromRGBO(23, 171, 144, 0.4);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AuthProvider>(
        builder: (context, _, child) => SingleChildScrollView(
          padding: screenLeftRightPadding,
          child: Column(
            children: [
              vSizedBox2,
              CustomText.ourText(
                "Otp has been sent to your email ${_.registerEmailController.text.trim()}",
                fontSize: 14.0,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
              vSizedBox2,
              Form(
                key: _.pinputKey,
                child: Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: _.pinputController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    // defaultPinTheme: defaultPinTheme,
                    validator: (value) {
                      return value?.isNotEmpty ?? false ? null : 'Fill the pin';
                    },
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   pinController.setText(value);
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
              vSizedBox4,
              CustomButton.elevatedButton("Send", () {
                if (_.pinputKey.currentState?.validate() ?? false) {
                  _.registerOtp(ctx: context);
                } else {
                  errorToast(msg: "Fill the otp");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
