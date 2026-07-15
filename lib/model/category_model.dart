class CategoriesModel {
  final int id;
  final String name;

  CategoriesModel({required this.id, required this.name});

  factory CategoriesModel.fromJson(Map<String, dynamic> data) {
    return CategoriesModel(
      id: (data['category_id'] as num)
          .toInt(), // لضمان عدم حدوث خطأ وجلب المعرف كرقم
      name: (data['name'] as String).trim(),
    );
  }
}
