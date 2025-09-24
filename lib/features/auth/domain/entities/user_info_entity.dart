class UserInfoEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String token;
  final String dp;

  UserInfoEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.token,
    required this.dp,
  });

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return UserInfoEntity(
      id: user['id'] ?? 0,
      firstName: user['first_name'] ?? '',
      lastName: user['last_name'] ?? '',
      email: user['email'] ?? '', // default empty string for email
      phone: user['phone'] ?? '',
      token: json['token'] ?? '',
      dp: user['profile_image'] ?? '', // default empty string if dp is missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'token': token,
      'profile_image': dp,
    };
  }
}