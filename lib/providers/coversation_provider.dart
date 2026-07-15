// lib/providers/conversations_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/conversation_service.dart';

class ConversationsProvider extends ChangeNotifier {
  final ConversationsService _service = ConversationsService();

  List<Map<String, dynamic>> conversations = [];
  bool isLoading = false;
  String? errorMessage;

  int get totalUnread =>
      conversations.fold(0, (sum, c) => sum + (c['unread_count'] as int? ?? 0));

  Future<void> fetchConversations() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      conversations = await _service.getConversations();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint("ConversationsProvider.fetchConversations error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void markConversationRead(int conversationId) {
    final index = conversations.indexWhere((c) => c['id'] == conversationId);
    if (index != -1) {
      conversations[index]['unread_count'] = 0;
      notifyListeners();
    }
    // silent background call — does not block navigation
    _service.markAsRead(conversationId).catchError((_) {});
  }

  // ── Update last message after sending (called from ChatPage) ──────────────
  void updateLastMessage(int conversationId, String message) {
    final index = conversations.indexWhere((c) => c['id'] == conversationId);
    if (index != -1) {
      conversations[index]['last_message'] = message;
      conversations[index]['last_message_at'] = DateTime.now()
          .toString()
          .substring(0, 16);
      // bubble to the top like WhatsApp
      final updated = conversations.removeAt(index);
      conversations.insert(0, updated);
      notifyListeners();
    }
  }
}
