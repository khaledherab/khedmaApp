//

import 'package:flutter/material.dart';
import 'package:graduation_project/services/api_sercice.dart';

class RatingService {
  final ApiService _api = ApiService();

  Future<void> submitRating({
    required int requestId,
    required int rating,
  }) async {
    final response = await _api.post('reviews', {
      'request_id': requestId,
      'rating': rating,
    });

    debugPrint("RatingService.submitRating response: $response");

    if (response == null) throw Exception("الاستجابة فارغة من الخادم");
  }

  Future<double> getAverageRating(int professionalId) async {
    final response = await _api.get('reviews/average/$professionalId');

    debugPrint("RatingService.getAverageRating response: $response");

    if (response == null) throw Exception("الاستجابة فارغة من الخادم");

    if (response is Map && response.containsKey('average_rating')) {
      return (response['average_rating'] as num).toDouble();
    }

    throw Exception("شكل الاستجابة غير متوقع: ${response.runtimeType}");
  }
}
