// الطلبات التي قدمها المستخدم

class RequestsService {
  // ── Fake data (delete this when API is ready) ────────────────────────
  static final List<Map<String, dynamic>> fakeRequests = [
    {
      "id": 1,
      "title": " عطل كهربائي في المنزل ",
      "date": "2026-05-31",
      "offers_count": 3,
    },
    {
      "id": 2,
      "title": "  غسالة أوتوماتيك",
      "date": "2026-05-30",
      "offers_count": 3,
    },
  ];

  // ── Fetch all requests ───────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 800)); // fake loading
    return List.from(fakeRequests);
  }

  // ── Add a request ────────────────────────────────────────────────────
  Future<void> addRequest(Map<String, dynamic> request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    fakeRequests.add(request);
  }

  // ── Delete a request ─────────────────────────────────────────────────
  Future<void> deleteRequest(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    fakeRequests.removeWhere((r) => r['id'] == id);
  }
}
