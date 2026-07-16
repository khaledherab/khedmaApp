// الطلبات عند المهني

// الطلبات المتاحة الان
import 'package:graduation_project/services/api_sercice.dart';

class ProfessionalRequestsService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getRequests() async {
    final response = await _apiService.get('professional/requests');

    if (response != null && response['requests'] != null) {
      return List<Map<String, dynamic>>.from(response['requests']);
    }

    // إذا لم توجد طلبات أو حدث خطأ، نرجع قائمة فارغة
    return [];
  }
}
