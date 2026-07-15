import 'package:flutter/material.dart';
import 'package:graduation_project/services/balance_service.dart';

// العمليات الاساسية على المحفظة

class BalanceProvider extends ChangeNotifier {
  final BalanceService _service = BalanceService();

  String balance = "0.00";
  bool isLoading = false;
  String? errorMessage;

  List<dynamic> transactions = [];

  Future<void> WalletData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final fetchedBalance = await _service.getWalletBalance();
      if (fetchedBalance != null) {
        balance = fetchedBalance;
      } else {
        errorMessage = "تعذر جلب الرصيد الحالي";
      }

      //  جلب العمليات
      final fetchedTransactions = await _service.getWalletTransactions();
      if (fetchedTransactions != null) {
        transactions = fetchedTransactions;
      } else {
        // يمكنك تخصيص رسالة خطأ هنا إذا رغبت، أو تركها فارغة
      }
    } catch (e) {
      errorMessage = "حدث خطأ أثناء الاتصال بالخادم";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
