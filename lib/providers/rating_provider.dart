// lib/providers/rating_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/providers/professional_provider.dart';
import '../services/rating_service.dart';

class RatingProvider extends ChangeNotifier {
  final RatingService _service = RatingService();

  int selectedRating = 0;
  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  void selectRating(int value) {
    selectedRating = value;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitRating({
    required int requestId,
    required int professionalId,
    required ProfessionalsProvider profProvider,
  }) async {
    if (selectedRating == 0) {
      errorMessage = "يرجى اختيار تقييم أولاً";
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.submitRating(requestId: requestId, rating: selectedRating);

      final double newAverage = await _service.getAverageRating(professionalId);

      // profProvider.updateProfessionalRating(professionalId, newAverage);

      isSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint("RatingProvider.submitRating error: $e");
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    selectedRating = 0;
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
