// // ارسال بيانات تسجيل الدخول و تسجيل الخروج الى قاعدة البيانات

import 'dart:io';

class AuthService {
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> saveProfessionalInfo({
    required String category,
    required String yearsExperience,
    required String description,
    required File toolsImage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // ── Save extra info (step 2: phone, role, governorate, city) ──────────────
  Future<void> saveUserInfo({
    required String phone,
    required String role,
    required String governorateId,
    String? cityId, // only required for "user" role
    String? specialty, // only for "professional" role (next page)
    String? experience, // only for "professional" role (next page)
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
