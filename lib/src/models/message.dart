import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/enum.dart';

// TODO: implement embeds
class Message {
  final Ulid id;
  final String? nonce;
  final Ulid channel;
  final Ulid author;
  final dynamic content;
  final List<Attachment>? attachments;
  final DateTime? edited;
  final List<Ulid>? mentions;
  final List<String>? replies;
  final Masquerade? masquerade;

  Message({
    required this.id,
    required this.nonce,
    required this.channel,
    required this.author,
    required this.content,
    required this.attachments,
    required this.edited,
    required this.mentions,
    required this.replies,
    required this.masquerade,
  });

  Message.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        nonce = json['nonce'],
        channel = Ulid(json['channel']),
        author = Ulid(json['author']),
        content = json['content'] is String
            ? json['content']
            : SystemUserContent.define(json['content']),
        attachments = json['attachments'] == null
            ? null
            : [for (final e in json['attachments']) Attachment.fromJson(e)],
        edited = json['edited'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['edited']['\$date']),
        mentions = json['mentions'] == null
            ? null
            : [for (final e in json['mentions']) Ulid(e)],
        replies = json['replies'] == null
            ? null
            : [for (final e in json['replies']) e],
        masquerade = json['masquerade'] == null
            ? null
            : Masquerade.fromJson(json['masquerade']);
}

class SystemUserContentType extends Enum<String> {
  static const text = SystemUserContentType._create('text');
  static const userAdded = SystemUserContentType._create('user_added');
  static const userRemove = SystemUserContentType._create('user_remove');
  static const userJoined = SystemUserContentType._create('user_joined');
  static const userLeft = SystemUserContentType._create('user_left');
  static const userKicked = SystemUserContentType._create('user_kicked');
  static const userBanned = SystemUserContentType._create('user_banned');
  static const channedRenamed =
      SystemUserContentType._create('channel_renamed');
  static const channelDescriptionChanged =
      SystemUserContentType._create('channel_description_changed');
  static const channelIconChanged =
      SystemUserContentType._create('channel_icon_changed');

  const SystemUserContentType._create(String value) : super(value);
  SystemUserContentType.from(String value) : super(value);
}

class SystemUserContent {
  final SystemUserContentType type;

  SystemUserContent({required this.type});

  SystemUserContent.fromJson(Map<String, dynamic> json)
      : type = SystemUserContentType.from(json['type']);

  factory SystemUserContent.define(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'text':
        return TextContent.fromJson(json);
      case 'user_added':
        return UserAddedContent.fromJson(json);
      case 'user_remove':
        return UserRemoveContent.fromJson(json);
      case 'user_joined':
        return UserJoinedContent.fromJson(json);
      case 'user_left':
        return UserLeftContent.fromJson(json);
      case 'user_kicked':
        return UserKickedContent.fromJson(json);
      case 'user_banned':
        return UserBannedContent.fromJson(json);
      case 'channel_renamed':
        return ChannelRenamedContent.fromJson(json);
      case 'channel_description_changed':
        return ChannelDescriptionChangedContent.fromJson(json);
      case 'channel_icon_changed':
        return ChannelIconChangedContent.fromJson(json);
      default:
        return UnknownContent.fromJson(json);
    }
  }
}

// the weird shit starts here........

class UnknownContent extends SystemUserContent {
  UnknownContent({required SystemUserContentType type}) : super(type: type);
  UnknownContent.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class TextContent extends SystemUserContent {
  final String content;

  TextContent({
    required SystemUserContentType type,
    required this.content,
  }) : super(type: type);

  TextContent.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        super.fromJson(json);
}

class UserAddedContent extends SystemUserContent {
  final Ulid id;
  final Ulid by;

  UserAddedContent({
    required SystemUserContentType type,
    required this.id,
    required this.by,
  }) : super(type: type);

  UserAddedContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        by = Ulid(json['by']),
        super.fromJson(json);
}

class UserRemoveContent extends SystemUserContent {
  final Ulid id;
  final Ulid by;

  UserRemoveContent({
    required SystemUserContentType type,
    required this.id,
    required this.by,
  }) : super(type: type);

  UserRemoveContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        by = Ulid(json['by']),
        super.fromJson(json);
}

class UserJoinedContent extends SystemUserContent {
  final Ulid id;

  UserJoinedContent({
    required SystemUserContentType type,
    required this.id,
  }) : super(type: type);

  UserJoinedContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        super.fromJson(json);
}

class UserLeftContent extends SystemUserContent {
  final Ulid id;

  UserLeftContent({
    required SystemUserContentType type,
    required this.id,
  }) : super(type: type);

  UserLeftContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        super.fromJson(json);
}

class UserKickedContent extends SystemUserContent {
  final Ulid id;

  UserKickedContent({
    required SystemUserContentType type,
    required this.id,
  }) : super(type: type);

  UserKickedContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        super.fromJson(json);
}

class UserBannedContent extends SystemUserContent {
  final Ulid id;

  UserBannedContent({
    required SystemUserContentType type,
    required this.id,
  }) : super(type: type);

  UserBannedContent.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['id']),
        super.fromJson(json);
}

class ChannelRenamedContent extends SystemUserContent {
  final String name;
  final Ulid by;

  ChannelRenamedContent({
    required SystemUserContentType type,
    required this.name,
    required this.by,
  }) : super(type: type);

  ChannelRenamedContent.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        by = Ulid(json['by']),
        super.fromJson(json);
}

class ChannelDescriptionChangedContent extends SystemUserContent {
  final Ulid by;

  ChannelDescriptionChangedContent({
    required SystemUserContentType type,
    required this.by,
  }) : super(type: type);

  ChannelDescriptionChangedContent.fromJson(Map<String, dynamic> json)
      : by = Ulid(json['by']),
        super.fromJson(json);
}

class ChannelIconChangedContent extends SystemUserContent {
  final Ulid by;

  ChannelIconChangedContent({
    required SystemUserContentType type,
    required this.by,
  }) : super(type: type);

  ChannelIconChangedContent.fromJson(Map<String, dynamic> json)
      : by = Ulid(json['by']),
        super.fromJson(json);
}

class Masquerade {
  final String? nickname;
  final String? avatar;

  Masquerade({required this.nickname, required this.avatar});

  Masquerade.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'],
        avatar = json['avatar'];
}
