class ConversationModel {
  final int id;
  final int requestId;
  final int customerId;
  final String customerName;
  final int professionalId;
  final String professionalName;
  final int otherPersonId;
  final String otherPersonName;
  final String lastMessage;
  final String lastMessageAt;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.requestId,
    required this.customerId,
    required this.customerName,
    required this.professionalId,
    required this.professionalName,
    required this.otherPersonId,
    required this.otherPersonName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(
    Map<String, dynamic> json,
    int loggedInUserId,
  ) {
    final int customerId = json['customer_id'] as int;
    final String customerName = json['customer_name'] as String? ?? '';
    final int professionalId = json['professional_id'] as int;
    final String professionalName = json['professional_name'] as String? ?? '';

    final bool iAmCustomer = loggedInUserId == customerId;
    final int otherPersonId = iAmCustomer ? professionalId : customerId;
    final String otherPersonName = iAmCustomer
        ? professionalName
        : customerName;

    final List<dynamic> messages = json['messages'] as List<dynamic>? ?? [];
    final String lastMessage = messages.isNotEmpty
        ? (messages.last['content'] as String? ?? '')
        : '';

    final String rawDate = json['updated_at'] as String? ?? '';
    final String lastMessageAt = rawDate.length >= 16
        ? rawDate.replaceFirst('T', ' ').substring(0, 16)
        : '';

    return ConversationModel(
      id: json['chat_id'] as int,
      requestId: json['request_id'] as int,
      customerId: customerId,
      customerName: customerName,
      professionalId: professionalId,
      professionalName: professionalName,
      otherPersonId: otherPersonId,
      otherPersonName: otherPersonName,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'request_id': requestId,
    'customer_id': customerId,
    'customer_name': customerName,
    'professional_id': professionalId,
    'professional_name': professionalName,
    'other_person_id': otherPersonId,
    'other_person_name': otherPersonName,
    'last_message': lastMessage,
    'last_message_at': lastMessageAt,
    'unread_count': unreadCount,
  };
}
