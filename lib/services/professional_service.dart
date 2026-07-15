// مقدمين الخدمة الموجودين في التطبيق
// يعرض المهنيين حسب التصنيف

import 'package:dio/dio.dart';
import 'package:graduation_project/services/api_sercice.dart'; // تأكد من استيراد مكتبة الاتصال الخاصة بك

class ProfessionalsService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getProfessionalsByCategory(
    String categoryId,
  ) async {
    try {
      final formData = FormData.fromMap({'category_id': categoryId});

      final response = await _apiService.post('professionals', formData);

      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      throw "فشل جلب المختصين من الخادم";
    }
  }
}
