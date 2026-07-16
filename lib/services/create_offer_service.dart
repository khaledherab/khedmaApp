// لارسال تفاصيل العرض الى قاعدة البيانات

import 'package:dio/dio.dart';
import 'package:graduation_project/services/api_sercice.dart';

class CreateOfferService {
  final ApiService _apiService = ApiService();

  Future<dynamic> submitOffer({
    required int requestId,
    required String details,
    required String duration,
    required String price,
  }) async {
    try {
      return await _apiService.post('service-requests/$requestId/offers', {
        'description': details,
        'duration': duration,
        'price': price,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final data = e.response?.data;
        if (data.containsKey('message')) {
          throw data['message'];
        }
      }
      throw "حدث خطأ أثناء الاتصال بالخادم";
    } catch (e) {
      throw "حدث خطأ غير متوقع";
    }
  }
}
