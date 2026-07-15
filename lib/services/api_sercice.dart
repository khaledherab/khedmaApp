import 'package:dio/dio.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/processing/dio_client.dart';
import 'package:graduation_project/processing/helper.dart';

class ApiService {
  final DioClient dioclient = DioClient();

  /// دالة مساعدة لتجهيز التوكن وارساله مع اي طلب او جلب اي بيانات
  Future<Options> _getAuthOptions() async {
    String? token = await PrefHelper.getToken();
    return Options(
      headers: {
        'Accept': 'application/json', // إخبار لارافيل أننا نتوقع استجابة JSON
        if (token != null)
          'Authorization': 'Bearer $token', // إضافة التوكن إذا كان موجوداً
      },
    );
  }

  /// get
  Future<dynamic> get(String endpoint) async {
    try {
      final responsse = await dioclient.dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// post
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final responsse = await dioclient.dio.post(
        endpoint,
        data: body,
        options: await _getAuthOptions(),
      );
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// update /put
  Future<dynamic> update(String endpoint, Map<String, dynamic>? body) async {
    try {
      final responsse = await dioclient.dio.put(
        endpoint,
        data: body,
        options: await _getAuthOptions(),
      );
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// delete
  Future<dynamic> delete(String endpoint, Map<String, dynamic>? body) async {
    try {
      final responsse = await dioclient.dio.delete(
        endpoint,
        data: body,
        options: await _getAuthOptions(),
      );
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }
}
