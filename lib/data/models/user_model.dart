import '../../domain/entities/user.dart';

// Local user profile model — saved to SharedPreferences after Clerk sign-in
class UserModel {
  UserModel({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.boardIds = const [],
  });

  final String id;
  final String? name;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final List<String> boardIds;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      boardIds: (json['boardIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'boardIds': boardIds,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      followersCount: followersCount,
      followingCount: followingCount,
      boardIds: boardIds,
    );
  }
}
