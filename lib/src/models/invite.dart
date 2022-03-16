import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/channel.dart';
import 'package:revolt/src/models/server.dart';
import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/enum.dart';

/// Channel invite
class ChannelInvite {
  /// Invite code
  final String code;

  ChannelInvite({required this.code});

  ChannelInvite.fromJson(Map<String, dynamic> json) : code = json['code'];
}

/// Invite type
class InviteType extends Enum<String> {
  static const server = InviteType._create('Server');

  InviteType.from(String value) : super(value);
  const InviteType._create(String value) : super(value);
}

/// Invite
abstract class Invite {
  /// Invite type
  final InviteType type;

  Invite({required this.type});

  Invite.fromJson(Map<String, dynamic> json)
      : type = InviteType.from(json['type']);

  factory Invite.define(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Server':
        return ServerInvite.fromJson(json);
      default:
        return UnknownInvite.fromJson(json);
    }
  }
}

/// Unknown invite subtype
/// If you are getting this type, please open an issue on github! :]
class UnknownInvite extends Invite {
  UnknownInvite({required InviteType type}) : super(type: type);
  UnknownInvite.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Server invite subtype
class ServerInvite extends Invite {
  /// Server ID
  final Ulid serverId;

  /// Server name
  final String serverName;

  /// Server icon
  final Attachment? serverIcon;

  /// Server banner
  final Attachment? serverBanner;

  /// Invited channel ID
  final Ulid channelId;

  /// Invited channel name
  final String channelName;

  /// Invited channel description
  final String? channelDescription;

  /// Invite author avatar
  final Attachment? userAvatar;

  /// Server members count
  final int memberCount;

  ServerInvite({
    required this.serverId,
    required this.serverName,
    this.serverIcon,
    this.serverBanner,
    required this.channelId,
    required this.channelName,
    this.channelDescription,
    this.userAvatar,
    required this.memberCount,
    required InviteType type,
  }) : super(type: type);

  ServerInvite.fromJson(Map<String, dynamic> json)
      : serverId = Ulid(json['server_id']),
        serverName = json['server_name'],
        serverIcon = json['server_icon'] == null
            ? null
            : Attachment.fromJson(json['server_icon']),
        serverBanner = json['server_banner'] == null
            ? null
            : Attachment.fromJson(json['server_banner']),
        channelId = Ulid(json['channel_id']),
        channelName = json['channel_name'],
        channelDescription = json['channel_description'],
        userAvatar = json['user_avatar'] == null
            ? null
            : Attachment.fromJson(json['user_avatar']),
        memberCount = json['member_count'],
        super.fromJson(json);
}

/// Type of joined invite
class JoinedInviteType extends Enum<String> {
  static const server = JoinedInviteType._create('Server');

  JoinedInviteType.from(String value) : super(value);
  const JoinedInviteType._create(String value) : super(value);
}

/// Minimal joined invite
abstract class JoinedInvite {
  /// Joined invite type
  final JoinedInviteType type;

  JoinedInvite({required this.type});

  JoinedInvite.fromJson(Map<String, dynamic> json)
      : type = JoinedInviteType.from('type');
}

/// Server joined invite
class ServerJoinedInvite extends JoinedInvite {
  /// Invited channel
  final Channel channel;

  /// Invited server
  final Server server;

  ServerJoinedInvite({
    required JoinedInviteType type,
    required this.channel,
    required this.server,
  }) : super(type: type);

  ServerJoinedInvite.fromJson(Map<String, dynamic> json)
      : channel = Channel.define(json['channel']),
        server = Server.fromJson(json['server']),
        super.fromJson(json);
}
