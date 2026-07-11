// لارسال تفاصيل العرض الى قاعدة البيانات

class CreateOfferService {
  // ارسال العرض الى طلب محدد -------------------------------
  Future<void> submitOffer({
    required int requestId,
    required String details,
    required String estimatedTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
