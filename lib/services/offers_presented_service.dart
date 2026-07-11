// العروض التي قدمها المهني
// هذه العروض ظاهرة في صفحة (العروض المقدمة) عند المهني

class OffersPresentedService {
  // ── Fetch all submitted offers (status included from DB) ─────────────────
  Future<List<Map<String, dynamic>>> getSubmittedOffers() async {
    await Future.delayed(const Duration(milliseconds: 700));

    // fake data — each offer includes its status from the "database"
    return [
      {
        "id": 1,
        "requestTitle": "إصلاح عطل كهربائي في المنزل",
        "clientName": "محمود محمود",
        "location": "دمشق، جرمانا",
        "date": "2026-05-31",
        "price": "150,000 ل.س",
        "details": "يمكنني إصلاح العطل خلال يوم واحد باستخدام أفضل المواد",
        "status": "قيد الانتظار",
      },
      {
        "id": 2,
        "requestTitle": "دهان غرفتين في منزل",
        "clientName": "علي غزال",
        "location": "حلب، الشهباء",
        "date": "2026-05-30",
        "price": "200,000 ل.س",
        "details": "سأقوم بدهان الغرفتين بأفضل أنواع الدهان خلال 3 أيام",
        "status": "مقبول",
      },
      {
        "id": 3,
        "requestTitle": "صيانة غسالة أوتوماتيك",
        "clientName": "بلال محمد",
        "location": "حمص، حي الإنشاءات",
        "date": "2026-05-28",
        "price": "75,000 ل.س",
        "details": "لدي خبرة 5 سنوات في صيانة الغسالات وسأصلحها خلال ساعتين",
        "status": "مرفوض",
      },
    ];
  }

  // ── Update status of one offer ────────────────────────────────────────────
  Future<void> updateStatus(int offerId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
