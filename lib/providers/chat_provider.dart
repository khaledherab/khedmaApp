// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  int? currentUserId;

  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  Future<void> fetchMessages(int conversationId) async {
    if (currentUserId == null) {
      await loadUserId();
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final rawMessage = await _service.getMessages(conversationId);

      messages = rawMessage.map((m) {
        final int senderId = int.tryParse(m['sender_id'].toString()) ?? 0;

        return {
          'id': m['message_id'],
          'content': m['message'],

          'is_mine': senderId == currentUserId,
          'created_at': m['created_at'],
        };
      }).toList();
    } catch (e) {
      errorMessage = "فشل تحميل الرسائل: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // دالة لجلب المعرف من الذاكرة
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();

    final idData =
        prefs.get('current_user_id') ?? prefs.get('user_id') ?? prefs.get('id');

    if (idData != null) {
      currentUserId = int.tryParse(idData.toString());
    }
    notifyListeners();
  }

  Future<bool> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return false;

    if (currentUserId == null) {
      await loadUserId();
    }

    isSending = true;
    notifyListeners();

    final optimisticId = DateTime.now().millisecondsSinceEpoch;
    final optimistic = {
      "id": optimisticId,
      "content": content.trim(),
      "is_mine": true,
      "created_at": DateTime.now().toUtc().toIso8601String(),
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
      return true; // إرجاع النجاح
    } catch (e) {
      final index = messages.indexWhere((m) => m['id'] == optimisticId);
      if (index != -1) {
        messages[index] = {...optimistic, 'failed': true, 'pending': false};
        notifyListeners();
      }
      errorMessage = "فشل إرسال الرسالة";
      return false; // إرجاع الفشل
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
