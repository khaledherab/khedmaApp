import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/offers_presented_provider.dart';
import 'package:provider/provider.dart';

class OffersPresented extends StatefulWidget {
  const OffersPresented({super.key});

  @override
  State<OffersPresented> createState() => offerspresented();
}

// ignore: camel_case_types
class offerspresented extends State<OffersPresented> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OffersPresentedProvider>().SubmittedOffers(),
    );
  }

  String translateStatus(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return "مقبول";
      case "rejected":
        return "مرفوض";
      case "pending":
      default:
        return "قيد الانتظار";
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return const Color(0xFF2E7D32);
      case "rejected":
        return Colors.red[700]!;
      case "pending":
      default:
        return const Color(0xFFF57F17);
    }
  }

  IconData statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Icons.check_circle_outline_rounded;
      case "rejected":
        return Icons.cancel_outlined;
      case "pending":
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  // ── Offer card --------------------------------------------
  Widget buildOfferCard(Map<String, dynamic> offer) {
    final String rawStatus = offer['status'] ?? 'pending';

    final String translatedStatus = translateStatus(rawStatus);
    final Color statuscolor = statusColor(rawStatus);
    final IconData statusicon = statusIcon(rawStatus);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statuscolor.withOpacity(0.10),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    Gap(4),
                    TextForm(
                      text: offer['date'] ?? '',
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),

                Row(
                  children: [
                    TextForm(
                      text: translatedStatus,
                      size: 16,
                      weight: FontWeight.bold,
                      color: statuscolor,
                    ),
                    Gap(5),
                    Icon(statusicon, color: statuscolor, size: 18),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextForm(
                  text: " الطلب : ${offer['request'] ?? ''}",
                  size: 18,
                  weight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                  align: TextAlign.right,
                ),

                Gap(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextForm(
                      text: offer['location'] ?? '',
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    Gap(6),
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1976D2),
                      size: 15,
                    ),
                    Gap(10),
                    TextForm(
                      text: offer['customer'] ?? '',
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    Gap(5),
                    Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF1976D2),
                      size: 15,
                    ),
                  ],
                ),

                Divider(color: Color(0xFFE3F2FD)),

                TextForm(
                  text: "محتوى العرض",
                  size: 20,
                  weight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                Gap(8),

                TextForm(
                  text: offer['offer_body'] ?? '',
                  size: 16,
                  align: TextAlign.right,
                  color: Colors.grey[600],
                ),
                TextForm(text: "السعر :${offer['price']} "),

                Gap(12),
                Divider(color: Color(0xFFE3F2FD)),
                Gap(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextForm(
                          text: offer['duration'] ?? "",
                          size: 16,
                          color: Colors.grey[700],
                          weight: FontWeight.w600,
                        ),
                        Gap(5),
                        Icon(
                          Icons.timer_outlined,
                          color: Color(0xFFF57F17),
                          size: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextForm(
                          text: "${offer['price'] ?? ''} ل.س",
                          size: 16,
                          color: Colors.green[700],
                          weight: FontWeight.bold,
                        ),
                        const Gap(5),
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OffersPresentedProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "العروض المقدمة سابقاً",
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
              onRetry: () =>
                  context.read<OffersPresentedProvider>().SubmittedOffers(),
            )
          : provider.offers.isEmpty
          ? AppStates.buildEmptyState(
              "لم تقدم أي عروض بعد",
              icon: Icons.description_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: provider.offers.length,
              itemBuilder: (context, index) =>
                  buildOfferCard(provider.offers[index]),
            ),
    );
  }
}
