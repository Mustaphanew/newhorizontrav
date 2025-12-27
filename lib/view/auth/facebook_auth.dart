import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';

class FacebookAuth extends StatelessWidget {
  const FacebookAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppConsts.sizeContext(context);
    final c = Get.find<AuthController>();
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: size.width * 0.9,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: (Get.isDarkMode) ? Colors.white : Colors.black,
          side: BorderSide(color: cs.tertiary, width: 1),
        ),
        onPressed: c.signInWithFacebook,
        icon: SvgPicture.asset(AppConsts.facebookLogo, width: 24, height: 24),
        label: Text('Sign in with Facebook'.tr),
      ),
    );
  }
}
