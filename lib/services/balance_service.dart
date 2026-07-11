//المحفظة والعمليات على المحفظة

class BalanceService {
  // ── Fetch current balance -------------------------
  Future<String> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return "10,000 ل.س"; // fake balance
  }

  // ── Fetch transactions--------------------------
  Future<List<Map<String, String>>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      {"type": "إيداع", "amount": "+ 500,000 ل.س", "date": "2026/05/27"},
      {"type": "سحب", "amount": "- 50,000 ل.س", "date": "2026/05/25"},
      {"type": "إيداع", "amount": "+ 150,000 ل.س", "date": "2026/05/20"},
      {"type": "سحب", "amount": "- 120,000 ل.س", "date": "2026/05/18"},
    ];
  }

  // ── Deposit------------------------------------------- ايداع رصيد
  Future<void> deposit(String amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // ── Withdraw ------------------------------- سحب رصيد
  Future<void> withdraw(String amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
