import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/permissions.dart';
import 'package:revolt/src/models/role.dart';
import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/enum.dart';

class ChannelType extends Enum<String> {
  static const savedMessages = ChannelType._create('SavedMessages');
  static const directMessage = ChannelType._create('DirectMessage');
  static const group = ChannelType._create('Group');
  static const text = ChannelType._create('TextChannel');
  static const voice = ChannelType._create('VoiceChannel');

  ChannelType.from(String value) : super(value);
  const ChannelType._create(String value) : super(value);
}

/// Basic channel
abstract class Channel {
  /// Channel ID
  final Ulid id;

  /// Channel type
  final ChannelType type;

  Channel({required this.id, required this.type});

  Channel.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        type = ChannelType.from(json['channel_type']);

  factory Channel.define(Map<String, dynamic> json) {
    switch (json['channel_type']) {
      case 'SavedMessages':
        return SavedMessagesChannel.fromJson(json);
      case 'DirectMessage':
        return DirectMessageChannel.fromJson(json);
      case 'Group':
        return Group.fromJson(json);
      case 'TextChannel':
        return ServerTextChannel.fromJson(json);
      case 'VoiceChannel':
        return ServerVoiceChannel.fromJson(json);
      default:
        return UnknownChannel.fromJson(json);
    }
  }
}

/// Text channel
abstract class TextChannel implements Channel {}

/// Voice channel
abstract class VoiceChannel implements Channel {}

/// Unknown channel
/// If you're getting it, please open an issue, because the actual channel is probably not implemented yet
class UnknownChannel extends Channel {
  UnknownChannel({
    required Ulid id,
    required ChannelType type,
  }) : super(id: id, type: type);
  UnknownChannel.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Saved message channel
class SavedMessagesChannel extends Channel implements TextChannel {
  /// User ID
  final Ulid user;

  SavedMessagesChannel({
    required this.user,
    required Ulid id,
    required ChannelType type,
  }) : super(id: id, type: type);

  SavedMessagesChannel.fromJson(Map<String, dynamic> json)
      : user = Ulid(json['user']),
        super.fromJson(json);
}

/// Direct messaging channel
class DirectMessageChannel extends Channel implements TextChannel {
  /// Whether this DM is active
  final bool active;

  /// List of user IDs who are participating in this DM
  final List<Ulid> recipients;

  /// ID of the last message in this channel
  final Ulid? lastMessageId;

  DirectMessageChannel({
    required Ulid id,
    required ChannelType type,
    required this.active,
    required this.recipients,
    this.lastMessageId,
  }) : super(id: id, type: type);

  DirectMessageChannel.fromJson(Map<String, dynamic> json)
      : active = json['active'],
        recipients = [for (final e in json['recipients']) Ulid(e)],
        lastMessageId = json['last_message_id'] == null
            ? null
            : Ulid(json['last_message_id']),
        super.fromJson(json);
}

/// Group channel
class Group extends Channel implements TextChannel {
  /// List of user IDs who are participating in this group
  final List<Ulid> recipients;

  /// Group name
  final String name;

  /// Group owner ID
  final Ulid owner;

  /// Group description
  final String? description;

  /// ID of the last message in this channel
  final Ulid? lastMessageId;

  /// Group icon
  final Attachment? icon;

  /// Permissions given to group members
  final ChannelPermissions? permissions;

  /// Whether this channel is marked as not safe for work
  final bool? nsfw;

  Group({
    required Ulid id,
    required ChannelType type,
    required this.recipients,
    required this.name,
    required this.owner,
    this.description,
    this.lastMessageId,
    this.icon,
    this.permissions,
    this.nsfw,
  }) : super(id: id, type: type);

  Group.fromJson(Map<String, dynamic> json)
      : recipients = [for (final e in json['recipients']) Ulid(e)],
        name = json['name'],
        owner = Ulid(json['owner']),
        description = json['description'],
        lastMessageId = json['last_message_id'] == null
            ? null
            : Ulid(json['last_message_id']),
        icon = json['icon'] == null ? null : Attachment.fromJson(json['icon']),
        permissions = json['permissions'] == null
            ? null
            : ChannelPermissions.fromRaw(json['permissions']),
        nsfw = json['nsfw'],
        super.fromJson(json);
}

/// Server channel
abstract class ServerChannel extends Channel {
  /// Server ID
  final Ulid server;

  /// Channel name
  final String name;

  /// Channel description
  final String? description;

  /// Permissions given to all users
  final ChannelPermissions? defaultPermissionsOverrides;

  /// Permissions given to roles
  final List<RolePermissionsOverrides>? rolePermissionsOverrides;

  /// Whether this channel is marked as not safe for work
  final bool? nsfw;

  ServerChannel({
    required Ulid id,
    required ChannelType type,
    required this.server,
    required this.name,
    this.description,
    this.defaultPermissionsOverrides,
    this.rolePermissionsOverrides,
    this.nsfw,
  }) : super(id: id, type: type);

  ServerChannel.fromJson(Map<String, dynamic> json)
      : server = Ulid(json['server']),
        name = json['name'],
        description = json['description'],
        defaultPermissionsOverrides = json['default_permissions'] == null
            ? null
            : ChannelPermissions.fromRaw(json['default_permissions']),
        rolePermissionsOverrides = json['role_permissions'] == null
            ? null
            : (json['role_permissions'] as Map<String, dynamic>)
                .entries
                .map((a) => RolePermissionsOverrides.fromRaw(a.key, a.value))
                .toList(),
        nsfw = json['nsfw'],
        super.fromJson(json);
}

/// Server textr channel
class ServerTextChannel extends ServerChannel implements TextChannel {
  /// ID of the last message in this channel
  final Ulid? lastMessageId;

  ServerTextChannel({
    required Ulid id,
    required ChannelType type,
    required Ulid server,
    required String name,
    String? description,
    ChannelPermissions? defaultPermissionsOverrides,
    List<RolePermissionsOverrides>? rolePermissionsOverrides,
    bool? nsfw,
    this.lastMessageId,
  }) : super(
          id: id,
          type: type,
          server: server,
          name: name,
          description: description,
          defaultPermissionsOverrides: defaultPermissionsOverrides,
          rolePermissionsOverrides: rolePermissionsOverrides,
          nsfw: nsfw,
        );

  ServerTextChannel.fromJson(Map<String, dynamic> json)
      : lastMessageId = json['last_message_id'] == null
            ? null
            : Ulid(json['last_message_id']),
        super.fromJson(json);
}

/// Server voice channel
class ServerVoiceChannel extends ServerChannel implements VoiceChannel {
  ServerVoiceChannel({
    required Ulid id,
    required ChannelType type,
    required Ulid server,
    required String name,
    String? description,
    ChannelPermissions? defaultPermissionsOverrides,
    List<RolePermissionsOverrides>? rolePermissionsOverrides,
    bool? nsfw,
  }) : super(
          id: id,
          type: type,
          server: server,
          name: name,
          description: description,
          defaultPermissionsOverrides: defaultPermissionsOverrides,
          rolePermissionsOverrides: rolePermissionsOverrides,
          nsfw: nsfw,
        );

  ServerVoiceChannel.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
