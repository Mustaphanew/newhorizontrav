// lib/repo/help_center_repo.dart
import 'package:flutter/foundation.dart';
import 'package:newhorizontrav/model/help_center_model.dart';
import 'package:newhorizontrav/utils/app_vars.dart';

class HelpCenterRepo {
  static const String uri = "/appm/jsons/help-center.json";

  Future<List<HelpCenterModel>?> fetchServerData() async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      final response = await AppVars.api.get(uri);

      // null => خطأ شبكة/سيرفر (تريدها تظل null)
      if (response == null) return null;

      if (response is List) {
        if (response.isEmpty) return <HelpCenterModel>[]; // لا توجد بيانات
        return response.whereType<Map>().map((e) => HelpCenterModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }

      // شكل غير متوقع => اعتبره خطأ
      return null;
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
      return null; // خطأ => null
    }
  }
}
