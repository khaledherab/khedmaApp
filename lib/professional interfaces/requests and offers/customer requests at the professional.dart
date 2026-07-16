import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types الطلبات الموجودة لدى المهني
class Requests_at_the_Professional extends StatefulWidget {
  const Requests_at_the_Professional({super.key});
  @override
  State<Requests_at_the_Professional> createState() => Requests();
}

// ignore: camel_case_types
class Requests extends State<Requests_at_the_Professional> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<ProfessionalRequestsProvider>().realRequests(),
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request) {
    String imageUrl = request['photo'] ?? '';
    //////////////////////////////////////
    if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        // إذا كان الرابط كاملاً ولكنه يحتوي على localhost أو 127.0.0.1 (للبيانات القديمة في الداتابيز)
        // نقوم باستبداله تلقائياً بالـ IP الجديد ليعمل على الهاتف الحقيقي بدون مشاكل
        imageUrl = imageUrl
            .replaceAll('127.0.0.1', '192.168.137.160')
            .replaceAll('localhost', '192.168.137.160');
      } else {
        // إذا كان السيرفر يرسل مجرد مسار نسبي (مثل service_requests/name.jpg)، نقوم بتركيبه هنا
        imageUrl = "http://192.168.137.160:8000/storage/$imageUrl";
      }
    }

    debugPrint("🔗 رابط الصورة الفعلي هو: $imageUrl");
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          //  يتم عرض الصورة فقط إذا كانت موجودة
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,

                httpHeaders: {
                  'Authorization':
                      'Bearer ${context.read<ProfessionalRequestsProvider>().token ?? ""}',
                },
                placeholder: (context, url) => Container(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),

          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // name + date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Colors.grey,
                        ),
                        Gap(4),
                        TextForm(
                          text: request['created_at'] ?? '',
                          size: 15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    // name + avatar
                    Row(
                      children: [
                        TextForm(
                          text: request['customer'] ?? '',
                          size: 20,
                          weight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                        Gap(8),
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

                Gap(8),
                Divider(color: Color(0xFFE3F2FD)),
                Gap(6),

                TextForm(
                  text: request['description'] ?? '',
                  align: TextAlign.right,
                  size: 20,
                ),

                Gap(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextForm(
                      text: request['location'] ?? '',
                      size: 17,
                      color: Colors.grey[700],
                    ),
                    Gap(4),
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1976D2),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: ButtonForm(
              onPressed: () {
                context.read<ProfessionalRequestsProvider>().selectRequest(
                  request,
                );
                Navigator.pushNamed(context, "requestdetails");
              },
              color: Color(0xFF1976D2),
              height: 44,
              title: "عرض التفاصيل",
              padding: EdgeInsets.symmetric(horizontal: 100),
              borderradius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfessionalRequestsProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "الطلبات",
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
                  context.read<ProfessionalRequestsProvider>().realRequests(),
            )
          : provider.requests.isEmpty
          ? AppStates.buildEmptyState(
              "لا توجد طلبات حالياً",
              icon: Icons.inbox_outlined,
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: provider.requests.length,
              itemBuilder: (context, index) =>
                  buildRequestCard(provider.requests[index]),
            ),
    );
  }
}
