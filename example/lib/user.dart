class User {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
  });

  // 从JSON中创建用户对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }

  // 将用户对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
