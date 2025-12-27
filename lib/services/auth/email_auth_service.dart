import 'package:firebase_auth/firebase_auth.dart';

/// خدمة البريد/كلمة المرور (تتعامل فقط مع FirebaseAuth)
/// - لا تستخدم fetchSignInMethodsForEmail لأنه أزيل في ^6.x.
/// - منطق حلّ التعارض Linking يكون في الـ Controller.
class EmailAuthService {
  EmailAuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// تسجيل الدخول بالبريد/كلمة المرور
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// إنشاء حساب + (اختياري) اسم العرض
  Future<UserCredential> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if ((displayName ?? '').trim().isNotEmpty) {
      await cred.user?.updateDisplayName(displayName!.trim());
    }
    return cred;
  }

  /// إرسال رسالة استرجاع كلمة المرور
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// إنشاء Credential لاستخدامه في reauth / link
  AuthCredential buildCredential({
    required String email,
    required String password,
  }) {
    return EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );
  }

  /// إعادة مصادقة المستخدم الحالي (إذا لزم)
  Future<UserCredential> reauthenticate({
    required String email,
    required String password,
  }) async {
    final current = _auth.currentUser;
    if (current == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'There is no signed-in user to reauthenticate.',
      );
    }
    final cred = buildCredential(email: email, password: password);
    return current.reauthenticateWithCredential(cred);
  }

  Future<void> signOut() => _auth.signOut();
}
