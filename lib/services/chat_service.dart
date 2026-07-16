//

import 'package:graduation_project/services/api_sercice.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final response = await _apiService.get('/chats/$conversationId/messages');

    if (response != null &&
        response is Map &&
        response.containsKey('messages') &&
        response['messages'] != null) {
      return List<Map<String, dynamic>>.from(response['messages']);
    }
    return [];
  }

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
}
