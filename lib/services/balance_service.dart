//المحفظة والعمليات على المحفظة

import 'package:graduation_project/services/api_sercice.dart';

class BalanceService {
  final ApiService _apiService = ApiService();

  Future<String?> getWalletBalance() async {
    final response = await _apiService.get('wallet');

    if (response != null && response['balance'] != null) {
      return response['balance'].toString();
    }
    return null;
  }

  Future<List<dynamic>?> getWalletTransactions() async {
    final response = await _apiService.get('wallet/transactions');
    if (response != null && response['transactions'] != null) {
      return response['transactions'];
    }
    return null;
  }
}
