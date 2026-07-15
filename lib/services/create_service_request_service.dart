// استقبال المعلومات من الحقول من صفحة طلب خدمة وتجهيزها لارسالها الى قاعدة البيانات

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/model/request_service_model.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ServiceRequestService {
  final ApiService _apiService = ApiService();

  Future<ServiceRequestModel> createRequest({
    required int categoryId,
    required String address,
    required String description,
    File? photo,
  }) async {
    try {
      Map<String, dynamic> data = {
        'category_id': categoryId,
        'address': address,
        'description': description,
      };

      // إضافة الصورة إذا كانت موجودة
      if (photo != null) {
        String fileName = photo.path.split('/').last;
        data['photo'] = await MultipartFile.fromFile(
          photo.path,
          filename: fileName,
        );
      }

      FormData formData = FormData.fromMap(data);

      final response = await _apiService.post('service-requests', formData);

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر. تأكد من صحة البيانات.");
      }

      if (response is Map<String, dynamic> && response.containsKey('request')) {
        return ServiceRequestModel.fromJson(response['request']);
      } else {
        throw Exception("شكل البيانات غير متوقع من السيرفر");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("Error in ServiceRequestService (createRequest): $e");
      throw "حدث خطأ أثناء إرسال الطلب، يرجى المحاولة لاحقاً";
    }
  }
}
