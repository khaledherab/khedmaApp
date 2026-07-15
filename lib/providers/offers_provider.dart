// اظهار العروض للطلبات المناسبة
import 'package:flutter/material.dart';
import 'package:graduation_project/services/offers_service.dart';

class OffersProvider extends ChangeNotifier {
  final OffersService _service = OffersService();

  List<Map<String, dynamic>> offers = [];
  Map<String, dynamic>? acceptedOffer;
  bool isLoading = false;
  bool isAccepting = false;
  bool isRejecting = false;
  String? errorMessage;

  Future<void> showOffers(int requestId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      offers = await _service.getOffersByRequest(requestId);
      acceptedOffer = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptOffer(int offerId, int requestId) async {
    isAccepting = true;
    errorMessage = null;
    notifyListeners();

    final List<Map<String, dynamic>> previous = List.from(offers);

    try {
      final index = offers.indexWhere((o) => o['offer_id'] == offerId);
      if (index != -1) {
        acceptedOffer = Map.from(offers[index]);
        acceptedOffer!['status'] = 'accepted';
      }

      offers = offers.where((o) => o['offer_id'] == offerId).toList();
      notifyListeners();

      await _service.acceptOffer(requestId, offerId);
    } catch (e) {
      offers = previous;
      acceptedOffer = null;
      errorMessage = "فشل قبول العرض، تأكد من اتصالك بالإنترنت";
      notifyListeners();

      throw e;
    } finally {
      isAccepting = false;
      notifyListeners();
    }
  }

  Future<void> rejectOffer(int offerId) async {
    isRejecting = true;
    notifyListeners();

    offers.removeWhere((o) => o['offer_id'] == offerId);
    notifyListeners();

    try {
      await _service.rejectOffer(offerId);
    } catch (_) {
      errorMessage = "تعذّر إرسال الرفض للخادم";
      notifyListeners();
    } finally {
      isRejecting = false;
      notifyListeners();
    }
  }
}
