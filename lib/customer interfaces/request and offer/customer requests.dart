import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/customer%20interfaces/request%20and%20offer/offers.dart';
import 'package:graduation_project/providers/requests_provider.dart';
import 'package:provider/provider.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => Request();
}

class Request extends State<Requests> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<RequestsProvider>().fetchRequests());
  }

  Widget buildRequestLayout(List<Map<String, dynamic>> requests) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Container(
          margin: EdgeInsets.only(bottom: 13),
          decoration: BoxDecoration(
            color: Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextForm(
                          text: "${request['offers_count'] ?? 0} عروض",
                          color: Colors.white,
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Gap(20),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OffersScreen(request: request),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.7),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: const Color(0x331976D2),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: TextForm(
                            text: "العروض ",
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // وضع شرط اذا ادرج المستخدم صورة مع الطلب تظهر هذه الصورة
                        // واذا لم يدرج صورة تظهر ايقونة
                        (request['photo_url'] != null &&
                                request['photo_url'].toString().isNotEmpty)
                            ? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    request['photo_url'],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          color: Colors.white70,
                                          size: 28,
                                        ),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.local_offer_rounded,
                                color: Colors.white70,
                                size: 28,
                              ),
                        Gap(12),
                        TextForm(
                          text: request['description'] ?? '',
                          align: TextAlign.right,
                          size: 22,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextForm(
                              text: request['created_at'] != null
                                  ? request['created_at'].toString()
                                  : '',
                              size: 16,
                              color: Colors.white70,
                            ),
                            Gap(6),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestsProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,

      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "الطلبات والعروض",
          style: TextStyle(
            color: Colors.indigo[800],
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? AppStates.buildErrorState(provider.errorMessage!, onRetry: () {})
          : provider.requests.isEmpty
          ? AppStates.buildEmptyState("لا توجد طلبات حتى الآن")
          : buildRequestLayout(provider.requests),
    );
  }
}
