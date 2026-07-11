// هذه العروض التي قدمها المهني
// وتلقى هذه العروض المستخدم كل طلب له عدد من العروض

class OffersService {
  // ── Fetch offers for a specific request ───────────────────────────────────
  Future<List<Map<String, dynamic>>> getOffersByRequest(int requestId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final Map<int, List<Map<String, dynamic>>> fakeData = {
      1: [
        {
          "id": 101,
          "provider": "المهندس أحمد",
          "details": "يمكنني اصلاح العطل بالسعر (40,000 ل.س)",
          "rate": 4.8,
          "status": "قيد الانتظار",
        },
        {
          "id": 102,
          "provider": "الفني خالد",
          "details": "يمكنني اصلاح العطل بالسعر (135,000 ل.س)",
          "rate": 4.5,
          "status": "قيد الانتظار",
        },
        {
          "id": 103,
          "provider": "المهندس علي",
          "details": "يمكنني اصلاح العطل بالسعر (150,000 ل.س)",
          "rate": 4.2,
          "status": "قيد الانتظار",
        },
      ],
      2: [
        {
          "id": 201,
          "provider": "المهندس عمر",
          "details": "يمكنني اصلاح العطل بالسعر (70,000 ل.س)",
          "rate": 4.7,
          "status": "قيد الانتظار",
        },
        {
          "id": 202,
          "provider": "المهندس محمد",
          "details": "يمكنني اصلاح العطل بالسعر (10,000 ل.س)",
          "rate": 4.0,
          "status": "قيد الانتظار",
        },
        {
          "id": 203,
          "provider": "المهندس عبدالله",
          "details": "يمكنني اصلاح العطل بالسعر (25,000 ل.س)",
          "rate": 4.6,
          "status": "قيد الانتظار",
        },
      ],
    };

    return fakeData[requestId] ?? [];
  }

  // ── Accept one offer → backend rejects all others automatically ──────────
  Future<void> acceptOffer(int offerId, int requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // ── Reject one offer → disappears permanently ────────────────────────────
  Future<void> rejectOffer(int offerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
