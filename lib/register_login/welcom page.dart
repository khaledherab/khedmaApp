import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/processing/helper.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class WelcomPage extends StatefulWidget {
  const WelcomPage({super.key});

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  bool _isLoading = false;

  Future<void> handleStartNow() async {
    // إظهار مؤشر التحميل
    setState(() => _isLoading = true);

    // البحث عن التوكن المحفوظ
    String? token = await PrefHelper.getToken();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      // إذا لم يكن هناك حساب مسجل مسبقاً، نوجهه لصفحة انشاء حساب او تسجيل دخول
      Navigator.of(context).pushReplacementNamed("createorlogin");
      return;
    }

    // إذا كان هناك توكن، نجلب بيانات الملف الشخصي لتحديد الدور
    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.realProfile();

    if (!mounted) return;

    if (success) {
      // توجيه المستخدم بناءً على نوع حسابه
      if (profileProvider.isProfessional) {
        Navigator.of(context).pushReplacementNamed("professionalhomepage");
      } else {
        Navigator.of(context).pushReplacementNamed("customerhomepage");
      }
    } else {
      // في حال فشل جلب البيانات (مثلاً التوكن انتهت صلاحيته)، نحذف التوكن ونوجهه للبداية
      await PrefHelper.clearToken();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("createorlogin");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Image.asset("images/logo first page.png"),
              Gap(20),
              TextForm(
                text: "أهلاً بك في تطبيق خدمة",
                align: TextAlign.center,
                size: 65,
                weight: FontWeight.bold,
                color: const Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(15),
              Container(
                padding: EdgeInsets.all(20),
                child: TextForm(
                  text:
                      "منصتك المتكاملة لطلب الخدمات المنزلية \nوالمهنية بكل سهولة وأمان \n نحن نربطك بأفضل المهنيين في منطقتك \nلضمان جودة العمل و سرعة التنفيذ ",
                  size: 28,
                  align: TextAlign.center,
                  weight: FontWeight.w600,
                  color: Color.fromARGB(255, 59, 115, 160),
                ),
              ),
              Gap(40),

              _isLoading
                  ? CupertinoActivityIndicator(color: Colors.blue)
                  : ButtonForm(
                      padding: EdgeInsets.symmetric(horizontal: 110),
                      borderradius: BorderRadiusGeometry.circular(20),
                      onPressed: handleStartNow,
                      title: "ابدأ الآن ",
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
