// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  final int currentUserId = 6;

  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  Future<void> fetchMessages(int conversationId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final rawMessage = await _service.getMessages(conversationId);

      messages = rawMessage
          .map(
            (m) => {
              'id': m['message_id'],
              'content': m['message'],
              'is_mine': (m['sender_id'] as int) == currentUserId,
              'created_at': m['created_at'],
            },
          )
          .toList();
    } catch (e) {
      errorMessage = "فشل تحميل الرسائل: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Send  message
  Future<void> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    isSending = true;
    notifyListeners();

    final optimisticId = DateTime.now().millisecondsSinceEpoch;
    final optimistic = {
      "id": optimisticId,
      "content": content.trim(),
      "is_mine": true,
      "created_at": DateTime.now().toString(),
      "pending": true,
    };
    messages.add(optimistic);
    notifyListeners();
    try {
      final saved = await _service.sendMessage(
        conversationId: conversationId,
        content: content.trim(),
      );

      final index = messages.indexWhere((m) => m['id'] == optimisticId);
      if (index != -1) {
        messages[index] = {
          'id': saved['message_id'],
          'content': saved['message'],
          'is_mine': true,
          'created_at': saved['created_at'],
          'pending': false,
        };
        notifyListeners();
      }
    } catch (e) {
      final index = messages.indexWhere((m) => m['id'] == optimisticId);
      if (index != -1) {
        messages[index] = {...optimistic, 'failed': true, 'pending': false};
        notifyListeners();
      }
      errorMessage = "فشل إرسال الرسالة";
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  void clear() {
    messages = [];
    isLoading = false;
    isSending = false;
    errorMessage = null;
    notifyListeners();
  }
}
