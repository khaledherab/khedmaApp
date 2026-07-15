import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _name;
  late TextEditingController _location;
  late TextEditingController _phone;
  late TextEditingController _email;
  late TextEditingController _description;
  late TextEditingController _experience;
  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileProvider>().profile;
    _name = TextEditingController(text: user?.name ?? '');
    _location = TextEditingController(text: user?.location ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _description = TextEditingController(text: user?.description ?? '');
    _experience = TextEditingController(text: user?.experience ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _phone.dispose();
    _email.dispose();
    _description.dispose();
    _experience.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final provider = context.read<ProfileProvider>();
    // اختيار مصدر الصورة
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextForm(
              text: "اختر مصدر الصورة",
              size: 22,
              weight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),

            Gap(16),
            ListTile(
              onTap: () => Navigator.pop(context, ImageSource.camera),
              leading: Icon(Icons.camera_alt, color: Color(0xFF1976D2)),
              title: TextForm(text: "الكاميرا", size: 20),
            ),
            ListTile(
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              leading: Icon(Icons.photo_library, color: Color(0xFF1976D2)),
              title: TextForm(text: "معرض الصور", size: 20),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70, // ضغط خفيف لتقليل حجم التحميل
      maxWidth: 600,
    );
    if (picked == null) return;

    await provider.pickAndUploadAvatar(File(picked.path));

    if (!mounted) return;
    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  // حفظ محتويات الحقول
  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    final bool isPro = provider.isProfessional;

    final Map<String, dynamic> dataToSend = {
      "name": _name.text.trim(),
      "location": _location.text.trim(),
      "phone": _phone.text.trim(),
      "email": _email.text.trim(),
    };
    if (isPro) {
      dataToSend["category"] = provider.profile?.category ?? '';
      dataToSend["bio"] = _description.text.trim();
      dataToSend["experience_years"] = _experience.text.trim();
    }

    await provider.updateProfile(dataToSend);

    if (!mounted) return;

    if (provider.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.successMessage!),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context, true);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Widget label(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextForm(
          text: text,
          size: 20,
          weight: FontWeight.bold,
          color: Color.fromARGB(255, 59, 115, 160),
        ),
        Gap(6),
        Icon(icon, color: const Color(0xFF1976D2), size: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final bool isPro = provider.isProfessional;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تعديل الملف الشخصي",
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
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Gap(20),
              Center(
                child: GestureDetector(
                  onTap: provider.isUploading ? null : pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xFFBBDEFB),
                        backgroundImage: provider.hasAvatar
                            ? MemoryImage(provider.avatarBytes!)
                            : null,

                        child: !provider.hasAvatar
                            ? Icon(
                                Icons.person,
                                size: 55,
                                color: Color(0xFF1976D2),
                              )
                            : null,
                      ),

                      // عرض مؤشر التحميل
                      if (provider.isUploading)
                        Positioned.fill(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      // camera button
                      Positioned(
                        left: 60,
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: provider.isUploading
                                ? Colors.grey
                                : Color(0xFF1976D2),
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(8),
              Center(
                child: TextForm(
                  text: provider.isUploading
                      ? "جاري رفع الصورة..."
                      : "اضغط لتغيير الصورة",
                  size: 15,
                  color: Colors.grey[500],
                ),
              ),
              Gap(24),
              //
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    label("الاسم", Icons.person),
                    Gap(8),
                    CustomTextForm(
                      hint: "الاسم الكامل",
                      myController: _name,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return "يرجى إدخال الاسم";
                        if (val.length < 4) return "الاسم قصير جداً";
                        return null;
                      },
                    ),
                    Gap(16),
                    label("الموقع", Icons.location_on),
                    Gap(8),
                    CustomTextForm(
                      hint: "المدينة والحي",
                      myController: _location,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return "يرجى إدخال الموقع";
                        return null;
                      },
                    ),

                    Gap(16),

                    label("رقم الهاتف", Icons.phone),
                    Gap(8),
                    CustomTextForm(
                      hint: "+963 9XXXXXXXX",
                      myController: _phone,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty)
                          return "يرجى إدخال رقم الهاتف";
                        if (val.trim().length < 10)
                          return "رقم الهاتف غير صحيح";
                        return null;
                      },
                    ),

                    Gap(16),

                    label("البريد الالكتروني", Icons.mark_email_read_rounded),
                    Gap(8),
                    CustomTextForm(
                      hint: "username@gmail.com",
                      myController: _email,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty)
                          return "يرجى إدخال البريد الالكتروني";
                        final regex = RegExp(
                          r"^[a-zA-Z0-9_%-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
                        );
                        if (!regex.hasMatch(val.trim()))
                          return "صيغة البريد غير صحيحة";
                        return null;
                      },
                    ),

                    // حقول خاصة فقط بالمهني
                    if (isPro) ...[
                      Gap(16),

                      label("وصف الخدمة", Icons.description_outlined),
                      Gap(8),
                      CustomTextForm(
                        hint: "اكتب وصفاً لخدماتك وخبرتك...",
                        myController: _description,
                        maxlines: 3,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "يرجى إدخال وصف الخدمة";
                          if (val.length < 10) return "الوصف قصير جداً";
                          return null;
                        },
                      ),
                      Gap(16),

                      label("سنوات الخبرة", Icons.workspace_premium_outlined),
                      Gap(8),
                      CustomTextForm(
                        hint: "مثال: 5",
                        myController: _experience,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty)
                            return "يرجى إدخال سنوات الخبرة";
                          if (int.tryParse(val.trim()) == null)
                            return "يرجى إدخال رقم صحيح";
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),

              Gap(24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (provider.isSaving || provider.isUploading)
                      ? null
                      : save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: provider.isSaving
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : TextForm(
                          text: "حفظ التغييرات",
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                ),
              ),
              Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
