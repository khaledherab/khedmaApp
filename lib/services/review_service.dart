import 'package:graduation_project/services/api_sercice.dart';

class ReviewService {
  final ApiService _apiService = ApiService();

  Future<double> getAverageRating(int professionalId) async {
    final response = await _apiService.get('reviews/average/$professionalId');

    return double.tryParse(response['average_rating'].toString()) ?? 4.0;
  }
}
