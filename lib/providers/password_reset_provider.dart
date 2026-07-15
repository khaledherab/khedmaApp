import 'package:flutter/material.dart';

import 'package:graduation_project/services/api_sercice.dart';

class PasswordResetProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  bool isLoading = false;

  String? errorMessage;
  String? successMessage;

  Future<bool> resetPasswordAction(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // إرسال الإيميل وكلمة السر معاً في طلب واحد
      final response = await _apiService.post('reset-password', {
        'email': email,
        'password': password,
      });

      // التحقق من أن السيرفر رد بنجاح
      if (response != null &&
          response is Map &&
          response.containsKey('message')) {
        successMessage = response['message']; // "تم إنشاء كلمة سر جديدة بنجاح"
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        // إذا كان هناك خطأ (مثل الإيميل غير موجود) السيرفر سيرد برسالة
        errorMessage = response?['message'] ?? "الإيميل خاطئ أو حدث خطأ ما";
      }
    } catch (e) {
      errorMessage = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
