// lib/services/chat_service.dart

import 'package:graduation_project/services/api_sercice.dart';
// import 'package:graduation_project/processing/dio_client.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final response = await _apiService.get('/chats/$conversationId/messages');

    if (response != null &&
        response is Map &&
        response.containsKey('messages')) {
      return List<Map<String, dynamic>>.from(response['messages']);
    }
    return [];
  }

  // ── Send a message
  Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final response = await _apiService.post(
      '/chats/$conversationId/messages/send',
      {'message': content},
    );
    return Map<String, dynamic>.from(response['data']);
  }

  //   // ── Mark all messages in conversation as read ──────────────────────────────
  //   Future<void> markAsRead(int conversationId) async {
  //     await Future.delayed(const Duration(milliseconds: 200));
  //   }

  //   // ── Error handler ──────────────────────────────────────────────────────────
  //   String handleError(DioException e) {
  //     if (e.type == DioExceptionType.connectionTimeout)
  //       return "انتهت مهلة الاتصال";
  //     if (e.response?.statusCode == 401) return "غير مصرح، سجّل دخولك مجدداً";
  //     if (e.response?.statusCode == 500) return "خطأ في الخادم، حاول لاحقاً";
  //     return "حدث خطأ غير متوقع";
  //   }
}
