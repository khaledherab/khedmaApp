//

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/services/auth_repo_service.dart';
import 'package:graduation_project/model/registration_madel.dart';
import 'package:graduation_project/model/user_model.dart';
import 'package:graduation_project/processing/helper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  RegistrationModel registerData = RegistrationModel();

  UserModel? currentUser;

  bool isLoading = false;
  String? errorMessage;

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /// الخطوة 1: إرسال (الاسم، الإيميل، كلمة السر)
  Future<bool> submitStep1() async {
    isLoading = true;
    clearError();
    notifyListeners();

    try {
      // إرسال البيانات واستقبال كائن المستخدم (والذي يحتوي على التوكن)
      currentUser = await _authRepo.registerUser(registerData);
      // حفظ التوكن في SharedPreferences لاستخدامه في الطلبات القادمة
      if (currentUser != null && currentUser!.token != null) {
        await PrefHelper.saveToken(currentUser!.token!);
      }

      isLoading = false;
      notifyListeners();
      return true; // نجاح، يمكن الانتقال للصفحة الثانية
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // فشل
    }
  }

  ///  إرسال (الهاتف، الدور، المحافظة، المدينة)
  Future<bool> submitStep2() async {
    isLoading = true;
    clearError();
    notifyListeners();

    try {
      String currentUserId = currentUser!.id.toString();
      await _authRepo.registerPublicInfo(registerData, currentUserId);

      isLoading = false;
      notifyListeners();
      return true; // نجاح
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // فشل
    }
  }

  ///   إرسال (بيانات المهني والصورة)
  Future<bool> submitStep3() async {
    isLoading = true;
    clearError();
    notifyListeners();

    try {
      String currentUserId = currentUser!.id.toString();
      await _authRepo.registerProfessionalInfo(registerData, currentUserId);

      // تفريغ البيانات بعد انتهاء التسجيل بالكامل بنجاح
      registerData = RegistrationModel();

      isLoading = false;
      notifyListeners();
      return true; // التسجيل اكتمل بنجاح تام!
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // فشل
    }
  }

  // --- دالة تسجيل الدخول ---
  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    clearError();
    notifyListeners();

    try {
      currentUser = await _authRepo.login(email, password);

      isLoading = false;
      notifyListeners();
      return true; // نجاح
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // فشل
    }
  }

  // --- دالة تسجيل الخروج ---
  Future<bool> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authRepo.logout();
      currentUser = null; // مسح بيانات المستخدم من الذاكرة

      await PrefHelper.clearToken();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
