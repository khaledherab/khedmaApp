// الطلبات التي قدمها المستخدم

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class RequestsService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      final response = await _apiService.get('customer/requests');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر.");
      }

      if (response is Map && response.containsKey('data')) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        throw Exception("شكل البيانات غير متوقع من السيرفر");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("Error in RequestsService (getRequests): $e");
      throw "حدث خطأ أثناء جلب الطلبات";
    }
  }
}
