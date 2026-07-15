class UserProfile {
  final String name;
  final String location;
  final String phone;
  final String email;
  final String role;
  final String description;
  final String experience;
  final String category;

  UserProfile({
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.role,
    required this.description,
    required this.experience,
    required this.category,
  });

  // دالة تحويل البيانات القادمة من السيرفر (JSON) إلى كائن
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer', // الافتراضي عميل
      // تم دمج المسميات (bio أو description) لتفادي أي تغيير من طرف السيرفر
      description:
          json['description']?.toString() ?? json['bio']?.toString() ?? '',
      experience:
          json['experience']?.toString() ??
          json['experience_years']?.toString() ??
          '',
      category: json['category']?.toString() ?? '',
    );
  }
}
