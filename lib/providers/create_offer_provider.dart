//

import 'package:flutter/material.dart';
import 'package:graduation_project/services/create_offer_service.dart';

class CreateOfferProvider extends ChangeNotifier {
  final CreateOfferService _service = CreateOfferService();

  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  Future<bool> submitOffer({
    required int requestId,
    required String details,
    required String duration,
    required String price,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.submitOffer(
        requestId: requestId,
        details: details,
        duration: duration,
        price: price,
      );

      isSuccess = true;
      return true;
    } catch (e) {
      errorMessage = "حدث خطأ أثناء إرسال العرض";
      return false;
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
