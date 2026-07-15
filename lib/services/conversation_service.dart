import 'package:flutter/material.dart';
import 'package:graduation_project/model/conversation_model.dart';
import 'package:graduation_project/processing/helper.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ConversationsService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getConversations() async {
    final response = await _api.get('chats');

    if (response == null) {
      throw Exception("الاستجابة فارغة من الخادم");
    }

    // ── Extract the chats array from { "message": "...", "chats": [...] } ──
    final List<dynamic> chats;
    if (response is Map && response.containsKey('chats')) {
      chats = response['chats'] as List<dynamic>;
    } else if (response is List) {
      chats = response;
    } else {
      throw Exception("شكل الاستجابة غير متوقع: ${response.runtimeType}");
    }

    // جلب معرف الذي مسجل دخول لمعرفة من هو الطرف الاخر
    final int loggedInUserId = await PrefHelper.getUserId() ?? 0;

    debugPrint("ConversationsService: loggedInUserId = $loggedInUserId");
    debugPrint("ConversationsService: ${chats.length} conversations received");

    return chats
        .map(
          (chat) => ConversationModel.fromJson(
            Map<String, dynamic>.from(chat as Map),
            loggedInUserId,
          ).toMap(),
        )
        .toList();
  }

  Future<void> markAsRead(int conversationId) async {
    await _api.post('chats/$conversationId/read', {});
  }
}
