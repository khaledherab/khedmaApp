import 'package:flutter/foundation.dart';
import 'package:graduation_project/services/complaint_service.dart';

///

class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _service = ComplaintService();

  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  Future<void> submitComplaint({
    required String message,
    required int requestId,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.submitComplaint(message: message, requestId: requestId);
      isSuccess = true;
    } catch (e) {
      errorMessage = "فشل إرسال الشكوى، حاول مجدداً";
      debugPrint("ComplaintProvider.submitComplaint error: $e");
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
