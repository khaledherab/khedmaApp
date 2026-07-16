import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/create_offer_provider.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:provider/provider.dart';

class CreateOfferForRequest extends StatefulWidget {
  const CreateOfferForRequest({super.key});

  @override
  State<CreateOfferForRequest> createState() => OfferDet();
}

class OfferDet extends State<CreateOfferForRequest> {
  final TextEditingController details = TextEditingController();
  final TextEditingController time = TextEditingController();
  final TextEditingController price = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late CreateOfferProvider provider;

  @override
  void initState() {
    provider = context.read<CreateOfferProvider>();
    super.initState();
  }

  @override
  void dispose() {
    details.dispose();
    time.dispose();
    price.dispose();
    Future.microtask(() {
      provider.reset();
    });
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final request = context.read<ProfessionalRequestsProvider>().selected;

    if (request == null) return;
    // احضار معرف الطلب الذي المهني يقدم عرض له
    bool success = await context.read<CreateOfferProvider>().submitOffer(
      requestId: request['request_id'],
      details: details.text.trim(),
      duration: time.text.trim(),
      price: price.text.trim(),
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? "حدث خطأ أثناء إرسال العرض",
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم ارسال العرض للزبون",
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      details.clear();
      time.clear();
      price.clear();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateOfferProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تقديم عرض",
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
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 8, right: 8, top: 0),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1976D2).withOpacity(0.08),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextForm(
                    text: "التفاصيل ",
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "",
                    myController: details,
                    maxlines: 8,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "يرجى إدخال تفاصيل العرض";
                      }
                      if (val.length < 10) {
                        return "التفاصيل قصيرة جداً، أضف المزيد";
                      }
                      return null;
                    },
                  ),
                  Gap(15),
                  TextForm(
                    text: "الوقت المقدر لإنهاء العمل",
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "ساعة 3",
                    myController: time,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "مثال: يومان / 3 ساعات";
                      }
                      return null;
                    },
                  ),
                  Gap(15),
                  TextForm(
                    text: "السعر الاجمالي",
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "300 مثلاً",
                    myController: price,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "مثال : ل.س 300 ";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Gap(20),

            if (provider.isSubmitting)
              Center(child: CircularProgressIndicator()),
            Center(
              child: ButtonForm(
                onPressed: submit,
                title: "ارسال",
                borderradius: BorderRadius.circular(15),
                padding: EdgeInsets.symmetric(horizontal: 80),
              ),
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }
}
