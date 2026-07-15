import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/processing/api_error.dart';

class ApiException {
  static ApiError handelError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: "انتهت مهلة الاتصال. يرجى التحقق من جودة الإنترنت لديك",
        );
      case DioExceptionType.sendTimeout:
        return ApiError(
          message: "استغرق إرسال البيانات وقتاً أطول من اللازم. حاول مجدداً",
        );
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: "تأخر السيرفر في الرد. قد يكون هناك ضغط على الشبكة",
        );
      case DioExceptionType.cancel:
        return ApiError(message: "تم إلغاء الطلب بنجاح");

      case DioExceptionType.badResponse:
        String serverMessage = "خطأ في استجابة السيرفر";

        // // محاولة استخراج رسالة الخطأ الدقيقة من لارافيل
        if (error.response != null && error.response!.data != null) {
          final data = error.response!.data;
          if (data is Map<String, dynamic>) {
            // إذا كان لارافيل يرسل رسالة خطأ عامة
            if (data.containsKey('message')) {
              serverMessage = data['message'];
            }
            // إذا كان لارافيل يرسل تفاصيل عن الحقول الخاطئة (Validation Errors)
            if (data.containsKey('errors')) {
              serverMessage = "يوجد نقص أو خطأ في البيانات المطلوبة!";
              debugPrint("تفاصيل الأخطاء من السيرفر: ${data['errors']}");
            }
          } else {
            serverMessage = data.toString();
          }
        }

        return ApiError(message: "خطأ ${error.response}: $serverMessage");
      // return ApiError(message: "خطأ في استجابة السيرفر ");
      case DioExceptionType.unknown:
        if (error.message != null &&
            error.message!.contains("SocketException")) {
          return ApiError(
            message:
                "لا يوجد اتصال بالإنترنت. تأكد من تفعيل الشبكة أو الواي فاي",
          );
        }
        return ApiError(message: "حدث خطأ غير متوقع. يرجى المحاولة لاحقاً");
      default:
        return ApiError(message: "عذراً، حدث خطأ ما. يرجى المحاولة من جديد");
    }
  }
}
