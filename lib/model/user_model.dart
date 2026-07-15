class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? phone;
  final String? token; // حفظ التوكن داخل الكائن لاستخدامه عند الحاجة

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.phone,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id'] ?? json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      phone: json['phone'],
      // التوكن قد نمرره يدوياً من الاستجابة الخارجية، أو نجده داخل الـ json
      token: token ?? json['token'],
    );
  }
}
