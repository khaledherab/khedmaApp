//

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/model/request_service_model.dart';
import 'package:graduation_project/services/create_service_request_service.dart';

class ServiceRequestProvider extends ChangeNotifier {
  final ServiceRequestService _service = ServiceRequestService();

  File? selectedImage;
  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;
  ServiceRequestModel? createdRequest;

  void setImage(File image) {
    selectedImage = image;
    errorMessage = null;
    notifyListeners();
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<void> submitRequest({
    required int categoryId,
    required String address,
    required String details,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      createdRequest = await _service.createRequest(
        categoryId: categoryId,
        address: address,
        description: details,
        photo: selectedImage,
      );

      isSuccess = true;
      selectedImage = null;
    } catch (e) {
      errorMessage = "فشل إرسال الطلب، حاول مجدداً";
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    selectedImage = null;
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    createdRequest = null;
    notifyListeners();
  }
}
