// الطلبات المتاحة للمهني
// يمكن للمهني رؤية تفاصيل الطلب و تقديم عرض له

import 'package:flutter/material.dart';
import 'package:graduation_project/processing/helper.dart';
import 'package:graduation_project/services/professional_requests_service.dart';

class ProfessionalRequestsProvider extends ChangeNotifier {
  final ProfessionalRequestsService _service = ProfessionalRequestsService();

  List<Map<String, dynamic>> requests = [];
  Map<String, dynamic>? selected;
  bool isLoading = false;
  String? errorMessage;
  String? token;

  Future<void> realRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      token = await PrefHelper.getToken();
      requests = await _service.getRequests();
    } catch (e) {
      errorMessage = "فشل تحميل الطلبات";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectRequest(Map<String, dynamic> request) {
    selected = request;
    notifyListeners();
  }
}
