import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Facebook Auth (v7.1.2)
/// - LoginResult.status لنتيجة الدخول
/// - AccessToken تغيّر: استخدم tokenString بدل token
class FacebookAuthService {
  FacebookAuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// إنشاء OAuthCredential من Facebook
  Future<OAuthCredential> getOAuthCredential() async {
    final LoginResult res = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
      // loginBehavior: LoginBehavior.dialogOnly, // اختياري
    );

    if (res.status != LoginStatus.success || res.accessToken == null) {
      final code = switch (res.status) {
        LoginStatus.cancelled => 'user-cancelled',
        LoginStatus.failed => 'facebook-login-failed',
        LoginStatus.operationInProgress => 'operation-in-progress',
        _ => 'facebook-unknown',
      };
      throw FirebaseAuthException(
        code: code,
        message: res.message ?? 'Facebook login failed.',
      );
    }

    // v7.x → tokenString
    final String token = res.accessToken!.tokenString;
    return FacebookAuthProvider.credential(token);
  }

  /// تسجيل الدخول إلى Firebase عبر Facebook
  Future<UserCredential> signIn() async {
    final credential = await getOAuthCredential();
    return _auth.signInWithCredential(credential);
  }

  /// ربط Facebook بالمستخدم الحالي
  Future<UserCredential> linkToCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No signed-in user to link.',
      );
    }
    final credential = await getOAuthCredential();
    return user.linkWithCredential(credential);
  }

  /// إنهاء جلسة Facebook فقط (لا يوقّع خروج FirebaseAuth)
  Future<void> signOutProvider() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }
}
