// مقدمين الخدمة الموجودين في التطبيق
// يعرض المهنيين حسب التصنيف

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ProfessionalsService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getProfessionalsByCategory(
    String categoryId,
  ) async {
    try {
      final formData = FormData.fromMap({'category_id': categoryId});
      final response = await _apiService.post('professionals', formData);

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }

      if (response is List) {
        return List<Map<String, dynamic>>.from(
          response.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }

      if (response is Map && response.containsKey('data')) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }

      throw Exception("شكل الاستجابة غير متوقع: ${response.runtimeType}");
    } catch (e) {
      debugPrint("ProfessionalsService.getProfessionalsByCategory error: $e");
      throw Exception("فشل جلب المختصين من الخادم");
    }
  }
}
