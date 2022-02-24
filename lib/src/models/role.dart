import 'package:revolt/src/models/permissions.dart';
import 'package:revolt/src/models/ulid.dart';

/// Server role
class Role {
  /// Role id
  final Ulid id;

  /// Role name
  final String name;

  /// Role permissions
  final RolePermissions permissions;

  /// Valid HTML color
  final String? color;

  /// Whether to display this role separately on the members list
  final bool? hoist;

  /// Role ranking
  /// A role with a smaller number will have permissions over roles with larger numbers
  final int? rank;

  Role.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        permissions = RolePermissions.fromRawTuple(json['permissions']),
        color = json['colour'],
        hoist = json['hoist'],
        rank = json['rank'];

  Role.fromRawId(String rawId, Map<String, dynamic> json)
      : id = Ulid(rawId),
        name = json['name'],
        permissions = RolePermissions.fromRawTuple(json['permissions']),
        color = json['colour'],
        hoist = json['hoist'],
        rank = json['rank'];
}

/// Role permissions
class RolePermissions {
  /// Server permissions
  final ServerPermissions server;

  /// Channel permissions
  final ChannelPermissions channel;

  RolePermissions.fromRawTuple(List<dynamic> raw)
      : server = ServerPermissions.fromRaw(raw[0] as int),
        channel = ChannelPermissions.fromRaw(raw[1] as int);

  RolePermissions.fromRaw(int rawServer, int rawChannel)
      : server = ServerPermissions.fromRaw(rawServer),
        channel = ChannelPermissions.fromRaw(rawChannel);
}
