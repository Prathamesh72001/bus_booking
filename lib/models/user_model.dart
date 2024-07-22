class UserModel {
  final String mobile;
  final String name;
  final String email;
  final String created_at;
  final String profile_image;

  UserModel({
    required this.mobile,
    required this.name,
    required this.email,
    required this.created_at,
    required this.profile_image,
  });

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      mobile: json['mobile'],
      name: json['name'],
      email: json['email'],
      created_at: json['created_at'],
      profile_image: json['profile_image'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'name': name,
      'email': email,
      'created_at': created_at,
      'profile_image': profile_image,
    };
  }
}