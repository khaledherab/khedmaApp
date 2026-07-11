// استقبال المعلومات من الحقول من صفحة طلب خدمة وتجهيزها لارسالها الى قاعدة البيانات

import 'dart:io';

class ServiceRequestService {
  Future<void> createRequest({
    required String category,
    required String address,
    required String details,
    File? image,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
