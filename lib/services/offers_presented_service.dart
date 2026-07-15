// العروض التي قدمها المهني
// هذه العروض ظاهرة في صفحة (العروض المقدمة) عند المهني

import 'package:graduation_project/services/api_sercice.dart';

class OffersPresentedService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getSubmittedOffers() async {
    final response = await _apiService.get('professional/offers');

    if (response != null && response['offers'] != null) {
      return response['offers'];
    }
    return [];
  }

  // تحديث حالة العرض (تركناها كما هي تحضيراً للمستقبل)
  Future<void> updateStatus(int offerId, String newStatus) async {
    // await _apiService.post('professional/offers/$offerId/status', {'status': newStatus});
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
