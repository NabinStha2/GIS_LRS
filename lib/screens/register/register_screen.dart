import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/app/dimensions.dart';
import 'package:gis_flutter_frontend/core/routing/route_name.dart';
import 'package:gis_flutter_frontend/providers/auth_provider.dart';
import 'package:gis_flutter_frontend/utils/custom_toasts.dart';
import 'package:gis_flutter_frontend/utils/unfocus_keyboard.dart';
import 'package:gis_flutter_frontend/utils/validation.dart';
import 'package:gis_flutter_frontend/widgets/custom_text.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../core/app/colors.dart';
import '../../core/config/regex_config.dart';
import '../../core/routing/route_navigation.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';

part './components/register_body.dart';
part './components/otp_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterBody();
  }
}
