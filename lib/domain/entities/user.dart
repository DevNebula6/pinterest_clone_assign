import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
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

  @override
  List<Object?> get props => [id];
}
