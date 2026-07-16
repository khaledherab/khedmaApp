// اظهار العروض للطلبات المناسبة
import 'package:flutter/material.dart';
import 'package:graduation_project/services/offers_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    notifyListeners();

    try {
      List<Map<String, dynamic>> allOffers = await _service.getOffersByRequest(
        requestId,
      );

      final prefs = await SharedPreferences.getInstance();
      List<String> rejectedIds = prefs.getStringList('rejected_offers') ?? [];

      offers = allOffers.where((offer) {
        return !rejectedIds.contains(offer['offer_id'].toString());
      }).toList();

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
    await _saveRejectedOfferId(offerId);

    offers.removeWhere((o) => o['offer_id'] == offerId);
    notifyListeners();

    try {
      await _service.rejectOffer(offerId);
    } catch (_) {}
  }

  Future<void> _saveRejectedOfferId(int offerId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rejectedIds = prefs.getStringList('rejected_offers') ?? [];

    if (!rejectedIds.contains(offerId.toString())) {
      rejectedIds.add(offerId.toString());
      await prefs.setStringList('rejected_offers', rejectedIds);
    }
  }
}
