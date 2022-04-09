import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/ulid.dart';

/// Server member
class Member {
  /// User ID
  final Ulid userId;

  /// Server ID
  final Ulid serverId;

  /// Custom member nickname
  final String? nickname;

  /// Custom member avatar
  final Attachment? avatar;

  /// List of member's roles
  final List<Ulid>? roles;

  Member({
    required this.userId,
    required this.serverId,
    this.nickname,
    this.avatar,
    this.roles,
  });

  Member.fromJson(Map<String, dynamic> json)
      : userId = Ulid(json['_id']['user']),
        serverId = Ulid(json['_id']['server']),
        nickname = json['nickname'],
        avatar =
            json['avatar'] == null ? null : Attachment.fromJson(json['avatar']),
        roles = json['roles'] == null
            ? null
            : [for (final e in json['roles']) Ulid(e)];
}
