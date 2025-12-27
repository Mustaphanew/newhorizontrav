import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google Sign-In (v7.x):
/// - GoogleSignIn أصبح singleton: GoogleSignIn.instance
/// - يجب استدعاء initialize() مرة واحدة ثم authenticate().
/// - للحصول على Credential لـ Firebase نستخدم idToken فقط.
class GoogleAuthService {
  GoogleAuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static bool _initialized = false;

  /// يُفضّل استدعاؤها في main() مرة واحدة.
  static Future<void> initialize({
    String? clientId,
    String? serverClientId,
    String? hostedDomain,
    String? nonce,
  }) async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
      hostedDomain: hostedDomain,
      nonce: nonce,
    );
    _initialized = true;
  }

  /// إنشاء OAuthCredential لاستخدامه مع signIn/link/reauth
  Future<OAuthCredential> getOAuthCredential() async {
    if (!_initialized) {
      await initialize(); // تهيئة افتراضيًا إذا لم تتم مسبقًا
    }

    // بدء تدفّق المصادقة التفاعلي
    final GoogleSignInAccount account =
        await GoogleSignIn.instance.authenticate();

    // الحصول على idToken (يكفي لـ Firebase)
    final GoogleSignInAuthentication auth = await account.authentication;
    final String? idToken = auth.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-google-id-token',
        message: 'Google idToken is null.',
      );
    }

    return GoogleAuthProvider.credential(idToken: idToken);
  }

  /// تسجيل الدخول إلى Firebase عبر Google
  Future<UserCredential> signIn() async {
    final credential = await getOAuthCredential();
    return _auth.signInWithCredential(credential);
  }

  /// ربط Google بالمستخدم الحالي
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

  /// إنهاء جلسة Google (لا يوقّع خروج FirebaseAuth)
  Future<void> signOutProvider() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  /// فصل حساب Google من الجهاز (اختياري)
  Future<void> disconnectProvider() async {
    try {
      await GoogleSignIn.instance.disconnect();
    } catch (_) {}
  }
}
