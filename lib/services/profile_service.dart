// لجلب بيانات البروفيل الخاصة بالمهني والمستخدم
//

import 'dart:io';

class ProfileService {
  // ── Fetch profile data ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return {
      "name": "خالد حيرب",
      "location": "اللاذقية - المشروع العاشر",
      "phone": "+963 930000000",
      "email": "khaled@gmail.com",
      "role":
          "professional", // "customer" or "professional" بدل بين مهني ومستخدم لحتى يتبدل الملف الشخصي
      // على حسب التوكن بيتغير الملف الشخصي (API)لما يجهز ال
      "avatar_url": "", // DB returns the image URL here
      "description":
          "كهربائي معتمد بخبرة 7 سنوات في الصيانة المنزلية والصناعية",
      "experience": "7",
    };
  }

  // ── Update profile text data ───────────────────────────────────────────────
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // ── Upload profile picture ─────────────────────────────────────────────────
  // role is passed so Laravel saves it in the correct folder:
  //   customer     → storage/customers/avatars/
  //   professional → storage/professionals/avatars/
  Future<String> uploadAvatar(File imageFile, String role) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // fake: return a placeholder URL
    return "https://via.placeholder.com/150";
  }
}
