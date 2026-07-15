import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/offers_provider.dart';
import 'package:graduation_project/providers/requests_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OffersScreen extends StatefulWidget {
  final Map<String, dynamic> request;

  const OffersScreen({super.key, required this.request});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OffersProvider>().showOffers(
        widget.request['request_id'],
      ),
    );
  }

  // رسالة الرفض ----------------------------
  void confirmReject(Map<String, dynamic> offer) {
    final provider = context.read<OffersProvider>();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "تأكيد الرفض",
      text: "هل أنت متأكد من رفض العرض؟\nلن يظهر هذا العرض مجدداً.",
      confirmBtnText: "تأكيد ",
      cancelBtnText: "إلغاء",
      confirmBtnColor: Color(0xFF1976D2),

      barrierDismissible: false,
      onConfirmBtnTap: () async {
        Navigator.pop(context);

        try {
          await provider.acceptOffer(
            offer['offer_id'],
            widget.request['request_id'],
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage ?? "حدث خطأ ما")),
          );
        }
        context.read<OffersProvider>().rejectOffer(offer['offer_id']);
      },
    );
  }

  // رسالة القبول --------------------------
  void confirmAccept(Map<String, dynamic> offer) {
    String providerName = offer['professional'] != null
        ? offer['professional']['name']
        : 'المهني';
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "تأكيد القبول",
      text:
          "هل تريد قبول عرض ${providerName}؟\nسيتم رفض جميع العروض الأخرى تلقائياً.",
      confirmBtnText: "قبول ",
      cancelBtnText: "إلغاء",
      confirmBtnColor: Color(0xFF2E7D32),
      barrierDismissible: false,
      onConfirmBtnTap: () async {
        Navigator.pop(context); // اغلاق الرسالة بعد تأكيد القبول

        await context.read<OffersProvider>().acceptOffer(
          offer['offer_id'],
          widget.request['request_id'],
        );

        if (!mounted) return;

        // حذف الطلب من صفحة الطلبات -----------------
        context.read<RequestsProvider>().removeRequest(
          widget.request['request_id'],
        );

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "تم قبول العرض",
          text:
              "تم قبول العرض بنجاح.\nيمكنك الآن التواصل مع المهني عبر صفحة الدردشة.",
          confirmBtnText: " اغلاق",
          confirmBtnColor: Color(0xFF1976D2),
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context); // اغلاق الرسالة
            Navigator.pop(context); // اغلاق صفحة العروض
          },
        );
      },
    );
  }

  // بطاقة العرض  ------------------------
  Widget buildOfferCard(Map<String, dynamic> offer) {
    final provider = context.watch<OffersProvider>();

    final Map<String, dynamic>? professional = offer['professional'];
    final String providerName = professional != null
        ? professional['name']
        : 'اسم غير متوفر';

    final double rating = professional != null && professional['rating'] != null
        ? double.parse(professional['rating'].toString())
        : 4.5;

    final String price = offer['price'] != null
        ? double.parse(offer['price'].toString()).toString()
        : '0';

    final String description = offer['description'];

    final String duration = offer['duration'];

    // دمج التفاصيل مع السعر
    final String formattedOfferText = "$description بالسعر ($price ل.س)";
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // التقييم
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$rating",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                Row(
                  children: [
                    TextForm(
                      text: providerName,
                      size: 17,
                      weight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                    Gap(10),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Gap(12),
            Divider(height: 1, color: AppColor.backgroundcolor),
            Gap(12),

            // تفاصيل العرض -----------------
            TextForm(
              text: formattedOfferText,
              align: TextAlign.right,
              size: 18,
              color: Colors.grey[700],
            ),
            Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextForm(
                  text: "وقت الإنجاز المقدر: $duration",
                  size: 14,
                  color: const Color(0xFF1976D2), // إعطاءه لون أزرق لتمييزه
                  weight: FontWeight.bold,
                ),
                const Gap(6),
                const Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: Color(0xFF1976D2),
                ),
              ],
            ),

            Gap(14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonForm(
                  onPressed: (provider.isAccepting || provider.isRejecting)
                      ? null
                      : () => confirmReject(offer),
                  title: "رفض العرض",
                  borderradius: BorderRadius.circular(15),
                  height: 40,
                  color: Color(0xFF1976D2),
                ),
                ButtonForm(
                  onPressed: context.watch<OffersProvider>().isAccepting
                      ? null
                      : () => confirmAccept(offer),
                  title: "قبول العرض",
                  borderradius: BorderRadius.circular(15),
                  height: 40,
                  color: Color(0xFF2E7D33),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OffersProvider>();
    final String title =
        widget.request['description'] ??
        widget.request['details'] ??
        'تفاصيل الطلب';
    final String date = widget.request['created_at'] != null
        ? widget.request['created_at'].toString().substring(0, 10)
        : (widget.request['date'] ?? '');

    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextForm(
          text: "العروض المقدمة",
          size: 30,
          weight: FontWeight.bold,
          color: Colors.indigo[800],
        ),
        actions: [
          IconButton(
            iconSize: 28,
            icon: Icon(Icons.arrow_forward_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),

      body: Column(
        children: [
          //  ملخص الطلب --------------
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    provider.isAccepting
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF2E7D32).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "تم القبول",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Gap(5),
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextForm(
                              text: "${provider.offers.length} عروض",
                              color: Colors.white,
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                          ),
                    Expanded(
                      child: TextForm(
                        text: title,
                        align: TextAlign.right,
                        size: 18,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextForm(text: date, size: 14, color: Colors.white70),
                    Gap(5),
                    Icon(Icons.calendar_today, color: Colors.white70, size: 13),
                  ],
                ),
              ],
            ),
          ),

          Gap(16),

          // قائمة العروض --------------------
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                ? AppStates.buildErrorState(
                    provider.errorMessage!,
                    onRetry: () => context.read<OffersProvider>().showOffers(
                      widget.request['request_id'],
                    ),
                  )
                : provider.offers.isEmpty && !provider.isAccepting
                ? AppStates.buildEmptyState("لا توجد عروض لهذا الطلب")
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
                    itemCount: provider.offers.length,
                    itemBuilder: (context, index) =>
                        buildOfferCard(provider.offers[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
