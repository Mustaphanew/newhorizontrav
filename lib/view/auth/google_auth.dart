import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';

class GoogleAuth extends StatelessWidget {
  const GoogleAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppConsts.sizeContext(context);
    final c = Get.find<AuthController>();

    return SizedBox(
      width: size.width * 0.9,
      child: ElevatedButton.icon(
        onPressed: c.signInWithGoogle,
        icon: SvgPicture.asset(AppConsts.googleLogo, width: 24, height: 24),
        label: Text('Sign in with Google'.tr),
      ),
    );
  }
}
