// الطلبات عند المهني

// الطلبات المتاحة الان
class ProfessionalRequestsService {
  Future<List<Map<String, dynamic>>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return [
      {
        "id": 1,
        "name": "محمود محمود",
        "details": "إصلاح عطل كهربائي في المنزل",
        "date": "2026-05-31",
        "location": "دمشق، جرمانا",
        "imageUrl":
            "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=500",
      },
      {
        "id": 2,
        "name": "علي غزال",
        "details": "دهان غرفتين في منزل",
        "date": "2026-05-30",
        "location": "حلب، الشهباء",
        "imageUrl":
            "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=500",
      },
      {
        "id": 3,
        "name": "بلال محمد",
        "details": "صيانة غسالة أوتوماتيك",
        "date": "2026-05-30",
        "location": "حمص، حي الإنشاءات",
        "imageUrl":
            "https://images.unsplash.com/photo-1562259949-e8e7689d7828?q=80&w=500",
      },
    ];
  }
}
