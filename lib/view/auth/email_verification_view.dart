import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newhorizontrav/controller/auth/auth_controller.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Email verification'.tr),
        centerTitle: true,
      ),
      body: GetBuilder<AuthController>(
        builder: (_) {
          final email = c.user?.email ?? '';
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please verify your email to continue'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (email.isNotEmpty)
                  Text(
                    'We sent a verification link to:'.tr + ' $email',
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),

                if (c.error != null && c.error!.trim().isNotEmpty) ...[
                  Text(c.error!, style: TextStyle(color: cs.error)),
                  const SizedBox(height: 8),
                ],

                ElevatedButton(
                  onPressed: c.sendVerificationEmail,
                  child: Text('Resend email'.tr),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: c.refreshUser,
                  child: Text('I have verified. Refresh'.tr),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: c.signOut,
                  child: Text('Sign out'.tr),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
