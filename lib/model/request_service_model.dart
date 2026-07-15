class ServiceRequestModel {
  final int requestId;
  final int categoryId;
  final String categoryName;
  final String description;
  final String address;
  final String? photoUrl;
  final String status;
  final int offersCount;
  final String createdAt;

  ServiceRequestModel({
    required this.requestId,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.address,
    this.photoUrl,
    required this.status,
    required this.offersCount,
    required this.createdAt,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      requestId: json['request_id'],
      categoryId: json['category']['id'],
      categoryName: json['category']['name'],
      description: json['description'],
      address: json['address'],
      photoUrl: json['photo_url'],
      status: json['status'],
      offersCount: json['offers_count'],
      createdAt: json['created_at'],
    );
  }
}
