import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newhorizontrav/utils/app_consts.dart';

class TermsAndPrivacyRichText extends StatelessWidget {
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const TermsAndPrivacyRichText({
    super.key,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: "${'By continuing, you have read and agree to our'.tr} ",
        style: TextStyle(
          fontSize: AppConsts.sm + 1,
          fontFamily: AppConsts.font,
          color: (Get.isDarkMode) ? Colors.white : Colors.black,
        ),
        children: [
          TextSpan(
            text: "Terms and Conditions".tr,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTermsTap,
          ),
          TextSpan(
            text: " ${'and'.tr} ",
          ),
          TextSpan(
            text: "Privacy Policy".tr,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
          ),
        ],
      ),
    );
  }
}
