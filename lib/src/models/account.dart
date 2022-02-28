import 'package:revolt/src/models/ulid.dart';

/// Account information
class AccountInfo {
  /// User ID
  final Ulid id;

  /// User email
  final String email;

  AccountInfo({required this.id, required this.email});

  AccountInfo.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        email = json['email'];
}
