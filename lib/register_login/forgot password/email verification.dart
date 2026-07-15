import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/password_reset_provider.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => EmailVerification();
}

class EmailVerification extends State<Verification> {
  final TextEditingController emailverifi = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailverifi.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PasswordResetProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تعيين كلمة السر",
          size: 40,
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
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Gap(100),
            TextForm(
              text:
                  "يرجى ادخال البريد الالكتروني للتحقق من انه موجود ثم يمكنك اعادة تعيين كلمة السر",
              size: 20,
              align: TextAlign.right,
            ),
            Gap(10),

            CustomTextForm(
              hint: "user@gmail.com",
              myController: emailverifi,

              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "ادخل بريدك الالكتروني";
                }
                final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9_%-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
                ).hasMatch(val);
                if (!emailValid) {
                  return "يرجى إدخال بريد إلكتروني صالح";
                }
                return null;
              },
            ),
            Gap(20),

            TextForm(
              text: "ادخل كلمة السر الجديدة ",
              size: 20,
              align: TextAlign.right,
            ),
            Gap(10),
            CustomTextForm(
              hint: "كلمة المرور الجديدة",
              myController: passwordController,
              validator: (val) {
                if (val == null || val.isEmpty)
                  return "أدخل كلمة المرور الجديدة";
                if (val.length < 6)
                  return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                return null;
              },
            ),

            Gap(50),
            if (provider.errorMessage != null)
              Center(
                child: TextForm(
                  text: provider.errorMessage!,
                  color: Colors.red,
                  size: 17,
                ),
              ),
            Gap(10),
            if (provider.isLoading) Center(child: CircularProgressIndicator()),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ButtonForm(
                onPressed: () async {
                  if (!formkey.currentState!.validate()) {
                    return;
                  }
                  bool success = await provider.resetPasswordAction(
                    emailverifi.text.trim(),
                    passwordController.text.trim(),
                  );
                  if (success && mounted) {
                    // نجحت العملية، نعود لصفحة تسجيل الدخول
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.successMessage ?? "تم التحديث"),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                title: "تغيير كلمة المرور",
                borderradius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
