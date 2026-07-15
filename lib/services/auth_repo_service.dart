import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/model/registration_madel.dart';
import 'package:graduation_project/model/user_model.dart';
import 'package:graduation_project/processing/api_error.dart';
import 'package:graduation_project/processing/helper.dart';
import 'package:graduation_project/services/api_sercice.dart';

class AuthRepo {
  final ApiService _service = ApiService();

  Future<UserModel> registerUser(RegistrationModel data) async {
    try {
      final response = await _service.post('register', data.toRegisterUser());
      if (response is ApiError) {
        throw response;
      }
      return UserModel.fromJson(response['user'], token: response['token']);
    } catch (e) {
      debugPrint("حدث خطأ أثناء حفظ المعلومات الأساسية.");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }

  Future<bool> registerPublicInfo(RegistrationModel data, String userId) async {
    try {
      final response = await _service.post(
        'register/basic-info',
        data.toPublicInfo(userId),
      );
      if (response is ApiError) {
        throw response;
      }
      return true;
    } catch (e) {
      debugPrint("حدث خطأ أثناء حفظ المعلومات العامة.");

      throw ApiError(message: e.toString());
    }
  }

  Future<bool> registerProfessionalInfo(
    RegistrationModel data,
    String userId,
  ) async {
    try {
      FormData formData = await data.toProfessionalInfo(userId);
      final response = await _service.post(
        'register/professional-info',
        formData,
      );

      if (response is ApiError) {
        throw response;
      }

      return true;
    } catch (e) {
      debugPrint("حدث خطأ أثناء حفظ بيانات المهني.");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _service.post('login', {
        'email': email,
        'password': password,
      });
      if (response is ApiError) {
        throw response;
      }
      final user = UserModel.fromJson(
        response['user'],
        token: response['token'],
      );
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      return user;
    } catch (e) {
      debugPrint("حدث خطأ أثناء تسجيل الدخول.");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _service.get('profile');
      if (response is ApiError) {
        throw response;
      }
      final profileData = response['data'] ?? response;
      return UserModel.fromJson(profileData);
    } catch (e) {
      debugPrint("لم نتمكن من جلب بيانات الملف الشخصي.");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _service.post('logout', {});
      if (response is ApiError) {
        throw response;
      }
      return true;
    } catch (e) {
      debugPrint("فشل تسجيل الخروج");
      if (e is ApiError) rethrow;
      throw ApiError(message: e.toString());
    }
  }
}
