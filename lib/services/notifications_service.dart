// استقبال الاشعارات من الداتا بيز و معالجتها

class NotificationsService {
  // ── Fetch all notifications for the logged-in user ─────────────────────────
  Future<List<Map<String, dynamic>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return [
      {
        "id": 1,
        "content": "تم قبول عرضك على طلب إصلاح الكهرباء",
        "date": "2026-06-01 10:30",
        "is_read": false,
        // "type": "offer_accepted", // used for icon color
      },
      {
        "id": 2,
        "content": "لديك عرض جديد على طلب دهان الغرفتين",
        "date": "2026-05-31 14:15",
        "is_read": false,
        // "type": "new_offer",
      },
      {
        "id": 3,
        "content": "تم رفض عرضك على طلب صيانة الغسالة",
        "date": "2026-05-30 09:00",
        "is_read": true,
        // "type": "offer_rejected",
      },
      {
        "id": 4,
        "content": "تم إرسال طلبك بنجاح وهو قيد المراجعة",
        "date": "2026-05-29 16:45",
        "is_read": true,
        // "type": "request_sent",
      },
    ];
  }

  // ── Mark one notification as read ──────────────────────────────────────────
  Future<void> markAsRead(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // ── Mark all notifications as read ────────────────────────────────────────
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
