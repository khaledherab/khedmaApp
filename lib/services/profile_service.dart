// لجلب بيانات البروفيل الخاصة بالمهني والمستخدم
//

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/processing/api_error.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ProfileService {
  final ApiService _apiService = ApiService();
  //
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get('profile');

      if (response is ApiError) {
        throw response;
      }
      final data = response['data'] ?? response;
      return data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> updatedData,
  ) async {
    try {
      // تحويل البيانات إلى FormData لدعم رفع الصور إذا وجدت
      FormData formData = FormData.fromMap(updatedData);

      final response = await _apiService.post('profile/update', formData);

      if (response is ApiError) {
        throw response;
      }

      final data = response['data'] ?? response['user'] ?? response;
      return data as Map<String, dynamic>;
    } catch (e) {
      debugPrint("حدث خطأ أثناء تعديل الملف الشخصي.");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }
}
