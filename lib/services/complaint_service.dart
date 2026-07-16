import 'package:graduation_project/services/api_sercice.dart';

///
///
class ComplaintService {
  final ApiService _service = ApiService();

  Future<void> submitComplaint({
    required String message,
    required int requestId,
  }) async {
    await _service.post('complaints', {
      'message': message,
      'request_id': requestId,
    });
  }
}
