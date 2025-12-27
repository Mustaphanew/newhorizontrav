import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth/email_auth_service.dart';
import '../../services/auth/google_auth_service.dart';
import '../../services/auth/facebook_auth_service.dart';

class AuthController extends GetxController {
  AuthController({
    EmailAuthService? emailService,
    GoogleAuthService? googleService,
    FacebookAuthService? facebookService,
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance,
       email = emailService ?? EmailAuthService(),
       google = googleService ?? GoogleAuthService(),
       facebook = facebookService ?? FacebookAuthService();

  // Firebase
  final FirebaseAuth _auth;

  // Services
  final EmailAuthService email;
  final GoogleAuthService google;
  final FacebookAuthService facebook;

  // UI State
  User? user;
  bool loading = false;

  /// مفتاح/نص إنجليزي للخطأ (لأغراض الترجمة)
  String? errorKey;

  /// النص المترجم النهائي للعرض
  String? error;

  bool loginMode = true; // true = Sign in, false = Sign up

  // لإدارة تعارض المزوّدات والربط لاحقًا
  AuthCredential? _pendingLinkCredential;
  String? _pendingEmail;

  StreamSubscription<User?>? _sub;

  @override
  void onInit() {
    super.onInit();
    user = _auth.currentUser;
    _sub = _auth.userChanges().listen((u) {
      user = u;
      update();
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ================= Helpers =================

  void toggleLoginMode() {
    loginMode = !loginMode;
    update();
  }

  void clearError() {
    errorKey = null;
    error = null;
    update();
  }

  /// تشغيل إجراء مع إظهار التحميل والتقاط أخطاء FirebaseAuth
  Future<void> _run(Future<void> Function() body, {Future<void> Function(FirebaseAuthException e)? onAuthError}) async {
    try {
      loading = true;
      clearError();
      await body();
    } on FirebaseAuthException catch (e) {
      if (onAuthError != null) {
        await onAuthError(e);
      } else {
        _setErrorKey(_friendlyKey(e));
      }
    } catch (_) {
      _setErrorKey('Something went wrong');
    } finally {
      loading = false;
      update();
    }
  }

  /// تحويل كود الخطأ إلى نص إنجليزي قابل للترجمة
  String _friendlyKey(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'account-exists-with-different-credential':
        return 'This email is linked to a different sign-in method';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return e.message?.trim().isNotEmpty == true ? e.message!.trim() : 'Something went wrong';
    }
  }

  void _setErrorKey(String key) {
    errorKey = key;
    error = key.tr;
    update();
  }

  /// هل يجب منع الوصول حتى يتم التحقق من البريد؟
  /// المنطق: إذا كان المستخدم الحالي مزوّده "password" وبريده غير مُفعّل → نعم
  bool get shouldGateForEmailVerification {
    final u = user;
    if (u == null) return false;
    final hasPasswordProvider = u.providerData.any((p) => p.providerId == 'password');
    return hasPasswordProvider && !(u.emailVerified);
  }

  /// إرسال رسالة التحقق بالبريد للمستخدم الحالي
  Future<void> sendVerificationEmail() async {
    final u = _auth.currentUser;
    if (u == null) return;
    await _run(() async {
      // ملاحظة: يمكنك تمرير ActionCodeSettings لإعداد رابط متابعة/دومين ديب لينك
      await u.sendEmailVerification();
      _setErrorKey('Verification email sent. Please check your inbox');
    });
  }

  /// إعادة تحميل بيانات المستخدم من السيرفر (لتحديث emailVerified)
  Future<void> refreshUser() async {
    await _run(() async {
      await _auth.currentUser?.reload();
      user = _auth.currentUser;
    });
  }

  Future<void> _linkPendingIfNeeded(User? signedInUser) async {
    if (_pendingLinkCredential == null || signedInUser == null) return;

    try {
      await signedInUser.linkWithCredential(_pendingLinkCredential!);
      _pendingLinkCredential = null;
      _pendingEmail = null;
      clearError();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked' || e.code == 'credential-already-in-use') {
        clearError();
      } else {
        _setErrorKey(_friendlyKey(e));
      }
    } catch (_) {
      _setErrorKey('Something went wrong');
    }
  }

  void _setPendingConflict({required FirebaseAuthException e, String? customKey}) {
    _pendingEmail = e.email;
    _pendingLinkCredential = e.credential;
    _setErrorKey(customKey ?? 'This email is linked to a different sign-in method');
  }

  // ================= Email/Password =================

  Future<void> signInWithEmail(String emailText, String password) async {
    await _run(() async {
      final res = await email.signIn(email: emailText, password: password);
      await _linkPendingIfNeeded(res.user);

      // ملاحظة: إذا الحساب غير مُفعّل، لن نمنع تسجيل الدخول،
      // لكن الواجهة ستعرض شاشة التحقق بناءً على shouldGateForEmailVerification.
      if (res.user != null && !res.user!.emailVerified) {
        _setErrorKey('Please verify your email to continue');
      }
    });
  }

  Future<void> signUpWithEmail({required String name, required String emailText, required String password}) async {
    await _run(
      () async {
        final res = await email.signUp(email: emailText, password: password, displayName: name);

        // إرسال رسالة التحقق بعد إنشاء الحساب مباشرة
        if (res.user != null) {
          await res.user!.sendEmailVerification();
          _setErrorKey('Verification email sent. Please check your inbox');
        }

        await _linkPendingIfNeeded(res.user);
      },
      onAuthError: (e) async {
        if (e.code == 'email-already-in-use') {
          _setPendingConflict(e: e, customKey: 'Email already in use');
        } else {
          _setErrorKey(_friendlyKey(e));
        }
      },
    );
  }

  Future<void> sendPasswordReset(String emailText) async {
    await _run(() async {
      await email.sendPasswordResetEmail(emailText);
      _setErrorKey('Password reset link sent to your email');
    });
  }

  // ================= Google =================

  Future<void> signInWithGoogle() async {
    await _run(
      () async {
        final res = await google.signIn();
        await _linkPendingIfNeeded(res.user);
        // عادة Google تكون emailVerified = true
      },
      onAuthError: (e) async {
        if (e.code == 'account-exists-with-different-credential') {
          _setPendingConflict(e: e, customKey: 'This email is linked to a different sign-in method');
        } else {
          _setErrorKey(_friendlyKey(e));
        }
      },
    );
  }

  // ================= Facebook =================
  Future<void> signInWithFacebook() async {
    await _run(
      () async {
        final res = await facebook.signIn();

        final fbUser = res.user;

        // إذا لم نحصل على بريد من فيسبوك، نسجّل خروج ونبلغ المستخدم
        if (fbUser == null || (fbUser.email == null || fbUser.email!.isEmpty)) {
          // إنهاء جلسة موفّر فيسبوك أولاً
          await facebook.signOutProvider();

          // ثم تسجيل خروج Firebase لتصفير الحالة
          await _auth.signOut();

          user = null;

          // رسالة واضحة للمستخدم (EN + .tr)
          _setErrorKey(
            'We could not get your email from Facebook. '
            'Please allow email permission on Facebook or sign in with Email/Google',
          );

          return;
        }

        // في حال وجود بريد، أكمل الربط إن كان هناك pending credential
        await _linkPendingIfNeeded(fbUser);
      },
      onAuthError: (e) async {
        if (e.code == 'account-exists-with-different-credential') {
          _setPendingConflict(e: e, customKey: 'This email is linked to a different sign-in method');
        } else {
          _setErrorKey(_friendlyKey(e));
        }
      },
    );
  }

  // ================= SignOut =================
  Future<void> signOut() async {
    await _run(() async {
      await google.signOutProvider();
      await facebook.signOutProvider();
      await _auth.signOut();

      _pendingLinkCredential = null;
      _pendingEmail = null;
      user = null;
      clearError();
    });
  }
}
