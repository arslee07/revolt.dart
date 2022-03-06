import 'package:revolt/src/models/ulid.dart';

/// Patial session object
class PartialSession {
  /// Session ID
  final Ulid id;

  /// Device name
  final String name;

  PartialSession({required this.id, required this.name});

  PartialSession.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        name = json['name'];
}

/// Session
class Session {
  /// Session ID
  final Ulid? id;

  /// User ID
  final Ulid userId;

  /// Session token
  final String token;

  /// Device name
  final String name;

  /// Web Push subscription
  final String? subscription;

  Session({
    this.id,
    required this.userId,
    required this.token,
    required this.name,
    this.subscription,
  });

  Session.fromJson(Map<String, dynamic> json)
      : id = json['_id'] == null ? null : Ulid(json['_id']),
        userId = Ulid(json['user_id']),
        token = json['token'],
        name = json['name'],
        subscription = json['subscription'];
}
