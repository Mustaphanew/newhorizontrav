import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppConsts.sizeContext(context);

    return GetBuilder<AuthController>(
      builder: (c) {
        // في حال تم الوصول للصفحة بدون مستخدم (مثلاً فتح رابط مباشر)
        if (c.user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final u = c.user!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'.tr), // إن أردت نفس العنوان السابق غيّره إلى: 'Sign in or create an account'.tr
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              width: size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: (u.photoURL != null && u.photoURL!.isNotEmpty)
                        ? NetworkImage(u.photoURL!)
                        : null,
                    child: (u.photoURL == null || u.photoURL!.isEmpty)
                        ? const Icon(Icons.person, size: 36)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (u.displayName?.trim().isNotEmpty == true) ? u.displayName! : 'User',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (u.email != null && u.email!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      u.email!,
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // زر تسجيل الخروج
                  ElevatedButton(
                    onPressed: c.signOut,
                    child: Text('Sign out'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print("u varified: ${u.emailVerified}");
                    },
                    child: Text('Verify'.tr),
                  ),

                  // إظهار لودر إن كان هناك عملية جارية (اختياري)
                  if (c.loading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
