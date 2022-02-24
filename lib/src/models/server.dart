import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/role.dart';
import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/flags_utils.dart';

/// Server model
class Server {
  /// Server ID
  final Ulid id;

  /// User ID of server owner
  final Ulid owner;

  /// Server name;
  final String name;

  /// Server description
  final String? description;

  /// Array of server channel IDs
  final List<Ulid> channels;

  /// Array of server categories
  final List<Category>? categories;

  /// System message channels
  final SystemMessages? systemMessages;

  /// Server roles
  final List<Role>? roles;

  /// Default permissions for all members
  final RolePermissions defaultPermissions;

  /// Server icon
  final Attachment? icon;

  /// Server banner
  final Attachment? banner;

  /// Whether this server is marked as not safe for work
  final bool? nsfw;

  /// Server flags
  final ServerFlags? flags;

  /// Whether to collect analytics on this server
  /// Enabled if server is discoverable
  final bool? analytics;

  /// Whether this server is discoverable
  final bool? discoverable;

  Server({
    required this.id,
    required this.owner,
    required this.name,
    this.description,
    required this.channels,
    this.categories,
    this.systemMessages,
    this.roles,
    required this.defaultPermissions,
    this.icon,
    this.banner,
    this.nsfw,
    this.flags,
    this.analytics,
    this.discoverable,
  });

  Server.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        owner = Ulid(json['owner']),
        name = json['name'],
        description = json['description'],
        channels = [for (final e in json['channels']) Ulid(e)],
        categories = json['categories'] == null
            ? null
            : [for (final e in json['categories']) Category.fromJson(e)],
        systemMessages = json['system_messages'] == null
            ? null
            : SystemMessages.fromJson(json['system_messages']),
        roles = json['roles'] == null
            ? null
            : ((json['roles'] as Map<String, dynamic>)
                .entries
                .map((a) => Role.fromRawId(a.key, a.value))).toList(),
        defaultPermissions =
            RolePermissions.fromRawTuple(json['default_permissions']),
        icon = json['icon'] == null ? null : Attachment.fromJson(json['icon']),
        banner =
            json['banner'] == null ? null : Attachment.fromJson(json['banner']),
        nsfw = json['nsfw'],
        flags =
            json['flags'] == null ? null : ServerFlags.fromRaw(json['flags']),
        analytics = json['analytics'],
        discoverable = json['discoverable'];
}

/// Server category
class Category {
  /// Category ID
  final Ulid id;

  /// Category title
  final String title;

  /// Category channels
  final List<Ulid> channels;

  Category({required this.id, required this.title, required this.channels});

  Category.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        title = json['title'],
        channels = [for (final e in json['channels']) Ulid(e)];
}

/// System message channels
class SystemMessages {
  /// Channel ID where user join events should be sent
  final Ulid? userJoined;

  /// Channel ID where user leave events should be sent
  final Ulid? userLeft;

  /// Channel ID where user kick events should be sent
  final Ulid? userKicked;

  /// Channel ID where user ban events should be sent
  final Ulid? userBanned;

  SystemMessages({
    this.userJoined,
    this.userLeft,
    this.userKicked,
    this.userBanned,
  });

  SystemMessages.fromJson(Map<String, dynamic> json)
      : userJoined =
            json['user_joined'] == null ? null : Ulid(json['user_joined']),
        userLeft = json['user_left'] == null ? null : Ulid(json['user_left']),
        userKicked =
            json['user_kicked'] == null ? null : Ulid(json['user_kicked']),
        userBanned =
            json['user_banned'] == null ? null : Ulid(json['user_banned']);
}

/// Server flags
class ServerFlags {
  /// Official Revolt server
  final bool officialRevoltServer;

  /// Verified community server
  final bool verifiedCommunityServer;

  ServerFlags({
    required this.officialRevoltServer,
    required this.verifiedCommunityServer,
  });

  ServerFlags.fromRaw(int raw)
      : officialRevoltServer = FlagsUtils.isApplied(raw, 1 << 0),
        verifiedCommunityServer = FlagsUtils.isApplied(raw, 1 << 1);
}
