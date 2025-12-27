import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';
import 'package:newhorizontrav/view/auth/email_verification_view.dart';

import 'package:newhorizontrav/view/auth/google_auth.dart';
import 'package:newhorizontrav/view/auth/facebook_auth.dart';
import 'package:newhorizontrav/view/auth/email_auth.dart';
import 'package:newhorizontrav/view/auth/termsandprivacytext.dart';
import 'package:newhorizontrav/view/profile/profile_view.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    final size = AppConsts.sizeContext(context);
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<AuthController>(
      init: Get.put(AuthController(), permanent: true),
      builder: (c) {
        if (c.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // في auth.dart (أو حيثما تعرض الـ Profile)
        if (c.user != null && c.shouldGateForEmailVerification) {
          return const EmailVerificationView(); // واجهة تحقق
        }

        // === مستخدم مسجل دخولًا: واجهة واحدة موحّدة ===
        if (c.user != null) {
          return const ProfileView();
        }

        // === ليس مسجل: شاشة المصادقة ===
        return Scaffold(
          appBar: AppBar(title: Text('Sign in or create an account'.tr), centerTitle: true),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),

                  // زر Google
                  const GoogleAuth(),
                  const SizedBox(height: 30),

                  // فاصل OR
                  Container(
                    width: size.width * 0.9,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(child: Divider(height: 0)),
                        Text("  ${'OR'.tr}  ", style: TextStyle(color: cs.tertiary, fontSize: 12)),
                        const Expanded(child: Divider(height: 0)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  // نموذج البريد/كلمة المرور
                  const EmailAuth(),
                  const SizedBox(height: 30),

                  Container(
                    width: size.width * 0.9,
                    child: Row(
                      children: [
                        Expanded(child: Divider(height: 0)),
                        Text("  ${'Other ways to sign in'.tr}  ", style: TextStyle(color: cs.tertiary, fontSize: 12)),
                        Expanded(child: Divider(height: 0)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  // زر Facebook
                  const FacebookAuth(),
                  const SizedBox(height: 24),

                  // نص الشروط والخصوصية
                  Container(
                    width: size.width * 0.90,
                    alignment: Alignment.center,
                    child: TermsAndPrivacyRichText(
                      onTermsTap: () {
                        // TODO: تطبيق فتح صفحة الشروط
                      },
                      onPrivacyTap: () {
                        // TODO: تطبيق فتح صفحة الخصوصية
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
