// لعرض البيانات القادمة من قاعدة البيانات في الصفحة المناسبة

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:graduation_project/model/user_profile_model.dart';
import 'package:graduation_project/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  UserProfile? profile;

  Uint8List? _avatarBytes;
  bool isLoading = false;
  bool isSaving = false;
  bool isUploading = false;

  String? errorMessage;
  String? successMessage;

  //  ارجاع الملف الشخصي على حسب الدور
  bool get isProfessional => profile?.role == 'professional';
  String get role => profile?.role ?? 'customer';

  Uint8List? get avatarBytes => _avatarBytes;
  bool get hasAvatar => _avatarBytes != null;

  //
  Future<bool> realProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> respocseData = await _service.getProfile();

      profile = UserProfile.fromJson(respocseData);

      await loadLocalAvatar(); // تحميل الصورة من ال SharedPreferences
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "فشل تحميل بيانات الملف الشخصي";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //  قراءة النص المحفوظ وتحويله لـ Bytes مجدداً
  Future<void> loadLocalAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final String userKey = profile?.email ?? 'unknown_user';

    final String? base64String = prefs.getString('avatar_$userKey');

    if (base64String != null && base64String.isNotEmpty) {
      _avatarBytes = base64Decode(base64String);
    } else {
      _avatarBytes = null;
    }
    notifyListeners();
  }

  // ── Update profile text data
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    isSaving = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await _service.updateProfile(updatedData);
      // جلب البيانات صحيحة وكاملة بعد التعديل
      await realProfile();
      successMessage = "تم تحديث الملف الشخصي بنجاح";
    } catch (e) {
      errorMessage = "فشل تحديث البيانات، حاول مجدداً";
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // 3. دالة اختيار الصورة وحفظها محلياً (تم ربطها بواجهة التعديل)
  Future<void> pickAndUploadAvatar(File pickedFile) async {
    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final bytes = await pickedFile.readAsBytes();
      _avatarBytes = bytes;

      final String base64String = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();

      final String userKey = profile?.email ?? 'unknown_user';
      await prefs.setString('avatar_$userKey', base64String);
    } catch (e) {
      errorMessage = "حدث خطأ أثناء حفظ الصورة محلياً";
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void clearProfileData() {
    profile = null;
    _avatarBytes = null;
    notifyListeners();
  }
}
