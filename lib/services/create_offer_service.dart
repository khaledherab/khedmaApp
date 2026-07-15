// لارسال تفاصيل العرض الى قاعدة البيانات

import 'package:graduation_project/services/api_sercice.dart';

class CreateOfferService {
  final ApiService _apiService = ApiService();

  Future<dynamic> submitOffer({
    required int requestId,
    required String details,
    required String duration,
    required String price,
  }) async {
    // الرابط الصحيح حسب الـ Postman
    return await _apiService.post('service-requests/$requestId/offers', {
      'description': details,
      'duration': duration,
      'price': price,
    });
  }
}
