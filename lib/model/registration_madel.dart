import 'dart:io';

import 'package:dio/dio.dart';

class RegistrationModel {
  String? name;
  String? email;
  String? password;

  String? phone;
  String? role;
  String? governorateId;
  String? cityId;

  String? categoryId;
  String? experienceYears;
  String? description;
  File? toolsImage;

  Map<String, dynamic> toRegisterUser() {
    return {'name': name, 'email': email, 'password': password};
  }

  Map<String, dynamic> toPublicInfo(String userId) {
    Map<String, dynamic> data = {
      'user_id': userId,
      'phone': phone,
      'role': role,
      'governorate_id': governorateId,
    };
    if (role == 'customer' && cityId != null) {
      data['city_id'] = cityId;
    }
    return data;
  }

  Future<FormData> toProfessionalInfo(String userId) async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'category_id': categoryId,
      'experience_years': experienceYears,
      'bio': description,
    };

    if (toolsImage != null) {
      String fileName = toolsImage!.path.split('/').last;
      data['tool_image'] = await MultipartFile.fromFile(
        toolsImage!.path,
        filename: fileName,
      );
    }
    return FormData.fromMap(data);
  }
}
