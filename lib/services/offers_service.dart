// هذه العروض التي قدمها المهني
// وتلقى هذه العروض المستخدم كل طلب له عدد من العروض

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class OffersService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getOffersByRequest(int requestId) async {
    try {
      final response = await _apiService.get('service-requests/$requestId');

      if (response != null && response is Map && response.containsKey('data')) {
        final data = response['data'];
        if (data.containsKey('offers')) {
          return List<Map<String, dynamic>>.from(data['offers']);
        }
      }
      return [];
    } on DioException catch (e) {
      throw ApiException.handelError(e).message;
    } catch (e) {
      debugPrint("Error fetching offers: $e");
      throw "فشل جلب العروض من الخادم";
    }
  }

  // ── قبول العرض
  Future<void> acceptOffer(int requestId, int offerId) async {
    try {
      String path = 'service-requests/$requestId/offers/$offerId/accept';

      // إرسال طلب POST (بدون body لأن المسار يكفي بناءً على Postman)
      await _apiService.post(path, {});
    } catch (e) {
      throw "فشل الاتصال بالخادم أثناء قبول العرض";
    }
  }

  // ── رفض العرض (معالج في الواجهة فقط كما طلبت) ──────
  Future<void> rejectOffer(int offerId) async {
    // يمكنك تركه كما هو أو إبقائه فارغاً
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
