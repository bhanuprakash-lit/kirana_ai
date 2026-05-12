class AppUser {
  final int userId;
  final String username;
  final String fullName;
  final String role;
  final int storeId;

  const AppUser({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
    required this.storeId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        userId: json['user_id'] as int,
        username: json['username'] as String,
        fullName: json['full_name'] as String,
        role: json['role'] as String,
        storeId: json['store_id'] as int,
      );

  Map<String, dynamic> toPrefs() => {
        'user_id': userId,
        'username': username,
        'full_name': fullName,
        'role': role,
        'store_id': storeId,
      };
}

class AuthResult {
  final String accessToken;
  final AppUser user;

  const AuthResult({required this.accessToken, required this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        accessToken: json['access_token'] as String,
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}
