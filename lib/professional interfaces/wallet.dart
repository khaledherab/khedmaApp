import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/balance_provider.dart';
import 'package:provider/provider.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BalanceProvider>().WalletData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BalanceProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "المحفظة",
          size: 30,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ],
      ),
      body: provider.isLoading
          ? AppStates.buildLoadingState()
          : provider.errorMessage != null
          ? AppStates.buildErrorState(
              provider.errorMessage!,
              onRetry: () => context.read<BalanceProvider>().WalletData(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextForm(
                    text: "الرصيد الحالي",
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  Card(
                    elevation: 2,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      child: TextForm(
                        text: provider.balance,
                        size: 30,
                        weight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  Gap(10),
                  Divider(),
                  // التحقق من وجود عمليات
                  provider.transactions.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                Gap(10),
                                TextForm(
                                  text: "لا يوجد عمليات لديك",
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              // العنوان يظهر فقط إذا كان هناك بيانات
                              TextForm(
                                text: "عمليات السحب والايداع",
                                size: 30,
                                weight: FontWeight.bold,
                              ),
                              Gap(10),
                              // القائمة
                              Expanded(
                                child: ListView.builder(
                                  itemCount: provider.transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        provider.transactions[index];
                                    // التحقق من النوع بناءً على القيمة القادمة من السيرفر (deposit)
                                    final isDeposit =
                                        transaction["type"] == "deposit";

                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: ListTile(
                                        title: TextForm(
                                          size: 30,
                                          text: isDeposit ? "إيداع" : "سحب",
                                          weight: FontWeight.bold,
                                          align: TextAlign.right,
                                          color: isDeposit
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        leading: TextForm(
                                          text: transaction['date'].toString(),
                                          color: Colors.grey,
                                        ),
                                        subtitle: TextForm(
                                          text: transaction['amount']
                                              .toString(),
                                          size: 20,
                                          weight: FontWeight.w600,
                                          align: TextAlign.right,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
