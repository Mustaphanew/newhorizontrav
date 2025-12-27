import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:newhorizontrav/controller/auth/auth_controller.dart';
import 'package:newhorizontrav/utils/app_consts.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({super.key});

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passCtrl;
  late final TextEditingController _confirmCtrl;

  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _confirmCtrl = TextEditingController();

    // عند تغير كلمة المرور أعد بناء الواجهة لتقرير إظهار/إخفاء حقل التأكيد
    _passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ---------------- Validators (EN + .tr) ----------------

  String? _validateName(String? value, {required bool enabled}) {
    if (!enabled) return null; // فقط في وضع إنشاء الحساب
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Name is required'.tr;
    if (v.length < 5) return 'Name is too short'.tr;
    if (v.length > 50) return 'Name is too long'.tr;
    final nameReg = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'\-\.]+$");
    if (!nameReg.hasMatch(v)) return 'Name has invalid characters'.tr;
    return null;
  }

  String? _validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required'.tr;
    if (v.contains(' ')) return 'Email must not contain spaces'.tr;
    final emailReg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailReg.hasMatch(v)) return 'Invalid email address'.tr;
    return null;
  }

  String? _validatePassword(String? value, {required bool isSignUp}) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Password is required'.tr;
    if (v.length < 6) return 'Password must be at least 6 characters'.tr;

    // تشدد أثناء إنشاء الحساب
    if (isSignUp) {
      if (v.contains(' ')) return 'Password must not contain spaces'.tr;
      final hasLetter = RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(v);
      final hasDigit = RegExp(r'\d').hasMatch(v);
      if (!hasLetter || !hasDigit) {
        return 'For better security, include letters and numbers'.tr;
      }
    }
    return null;
  }

  // هل كلمة المرور صالحة بما يكفي لإظهار حقل التأكيد؟
  bool _shouldShowConfirm(String v) {
    if (v.isEmpty) return false;
    if (v.length < 6) return false;
    if (v.contains(' ')) return false;
    final hasLetter = RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);
    return hasLetter && hasDigit;
  }

  String? _validateConfirm(String? value, {required bool enabled}) {
    if (!enabled) return null; // لا حاجة للتحقق إن كان الحقل مخفيًا
    final v = value ?? '';
    if (v.isEmpty) return 'Please confirm your password'.tr;
    if (v != _passCtrl.text) return 'Passwords do not match'.tr;
    return null;
  }

  // ---------------- Actions ----------------

  Future<void> _onSubmit(AuthController c) async {
    FocusScope.of(context).unfocus();

    final isSignIn = c.loginMode;
    final showConfirm = !isSignIn && _shouldShowConfirm(_passCtrl.text);

    // تحقّق محلي لكل الحقول المعروضة حاليًا
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    // إذا كان إنشاء حساب ولم تظهر خانة التأكيد بعد، نمنع الإرسال
    if (!isSignIn && !showConfirm) {
      // كلمة المرور لم تصبح قوية بعد لعرض خانة التأكيد
      return;
    }

    if (isSignIn) {
      await c.signInWithEmail(_emailCtrl.text, _passCtrl.text);
    } else {
      await c.signUpWithEmail(name: _nameCtrl.text, emailText: _emailCtrl.text, password: _passCtrl.text);
    }
  }

  Future<void> _onForgot(AuthController c) async {
    FocusScope.of(context).unfocus();
    final emailErr = _validateEmail(_emailCtrl.text);
    if (emailErr != null) {
      _formKey.currentState?.validate(); // لعرض رسالة الخطأ أسفل البريد
      return;
    }
    await c.sendPasswordReset(_emailCtrl.text);
    if (c.error == null) {
      Get.snackbar('Success'.tr, 'Password reset link sent to your email'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = AppConsts.sizeContext(context);

    return GetBuilder<AuthController>(
      builder: (c) {
        final isSignIn = c.loginMode;
        final showConfirm = !isSignIn && _shouldShowConfirm(_passCtrl.text);

        // عند التحول للوضع تسجيل الدخول، نظّف حقل التأكيد
        if (isSignIn && _confirmCtrl.text.isNotEmpty) {
          _confirmCtrl.clear();
        }

        return Container(
          width: size.width * 0.9,
          padding: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled, // اعرض الأخطاء عند الإرسال
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isSignIn) ...[
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: const ValueKey('nameField'),
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Name'.tr, prefixIcon: const Icon(FontAwesomeIcons.user)),
                    validator: (v) => _validateName(v, enabled: !isSignIn),
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const ValueKey('emailField'),
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(labelText: 'Email'.tr, prefixIcon: const Icon(Icons.email_outlined)),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const ValueKey('passField'),
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: showConfirm ? TextInputAction.next : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!showConfirm) _onSubmit(c);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password'.tr,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (v) => _validatePassword(v, isSignUp: !isSignIn),
                ),

                // حقل تأكيد كلمة المرور — يظهر فقط في وضع التسجيل وبعد صلاحية كلمة المرور
                if (showConfirm) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: const ValueKey('confirmField'),
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(c),
                    decoration: InputDecoration(
                      labelText: 'Confirm password'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (v) => _validateConfirm(v, enabled: showConfirm),
                  ),
                ],

                // Forgot password
                InkWell(
                  onTap: () => _onForgot(c),
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(top: 4, bottom: 4, start: 8),
                    child: Text(
                      'Forgot your password?'.tr,
                      style: TextStyle(color: AppConsts.secondaryColor, fontSize: AppConsts.sm),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Sign in / Sign up
                ElevatedButton(onPressed: () => _onSubmit(c), child: Text(isSignIn ? 'Sign in'.tr : 'Sign up'.tr)),

                const SizedBox(height: 12),

                // Toggle mode
                TextButton(
                  style: ElevatedButton.styleFrom(side: BorderSide(color: AppConsts.secondaryColor, width: 1)),
                  onPressed: () {
                    // عند التبديل، أعد ضبط حقول كلمات المرور
                    _passCtrl.clear();
                    _confirmCtrl.clear();
                    c.toggleLoginMode();
                  },
                  child: Text(isSignIn ? 'Create an new account'.tr : 'I have an account, sign in'.tr),
                ),

                // رسالة خطأ عامة من الكنترولر (مترجمة مسبقًا داخل الكنترولر)
                if (c.error != null && c.error!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    c.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

}
