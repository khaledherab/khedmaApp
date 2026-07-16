// معالجة الطلبات التي قدمها المستخدم
//

import 'package:flutter/material.dart';
import 'package:graduation_project/services/requests_service.dart';

class RequestsProvider extends ChangeNotifier {
  final RequestsService _service = RequestsService();

  List<Map<String, dynamic>> requests = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      requests = await _service.getRequests();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeRequest(int requestId) {
    requests.removeWhere((r) => r['request_id'] == requestId);
    notifyListeners();
  }

  void decrementOfferCount(int requestId) {
    final index = requests.indexWhere((r) => r['request_id'] == requestId);

    if (index != -1) {
      int currentCount =
          int.tryParse(requests[index]['offers_count'].toString()) ?? 0;

      if (currentCount > 0) {
        requests[index]['offers_count'] = currentCount - 1;
        notifyListeners();
      }
    }
  }
}
