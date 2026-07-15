// اظهار المهنيين على حسب التصنيف المسجلين فيه

import 'package:flutter/material.dart';
import 'package:graduation_project/services/professional_service.dart';

class ProfessionalsProvider extends ChangeNotifier {
  final ProfessionalsService _service = ProfessionalsService();

  List<Map<String, dynamic>> professionals = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> showProfessionals(String categoryId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      professionals = await _service.getProfessionalsByCategory(categoryId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateProfessionalRating(int professionalId, double newAverage) {
    final index = professionals.indexWhere(
      (p) => p['professional_id'] == professionalId,
    );
    if (index != -1) {
      professionals[index]['rating'] = newAverage;
      notifyListeners();
    }
  }

  void notifyListeners() {}
}
