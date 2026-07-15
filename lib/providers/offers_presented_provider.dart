import 'package:flutter/material.dart';
import 'package:graduation_project/services/offers_presented_service.dart';

// معالجة العروض التي قدمها المنهي حسب حالتها
// العرض اما مقبول او مرفوض او قيد الانتظار

class OffersPresentedProvider extends ChangeNotifier {
  final OffersPresentedService _service = OffersPresentedService();

  List<Map<String, dynamic>> offers = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> SubmittedOffers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.getSubmittedOffers();
      offers = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      errorMessage = "فشل تحميل العروض المقدمة";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOfferStatus(int offerId, String newStatus) async {
    final index = offers.indexWhere((o) => o['offer_id'] == offerId);
    if (index == -1) return;

    final String oldStatus = offers[index]['status'];

    offers[index]['status'] = newStatus;
    notifyListeners();

    try {
      await _service.updateStatus(offerId, newStatus);
    } catch (e) {
      offers[index]['status'] = oldStatus;
      errorMessage = "فشل تحديث الحالة";
      notifyListeners();
    }
  }
}
