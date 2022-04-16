import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/models/user.dart';
import 'package:revolt/src/utils/builder.dart';
import 'package:revolt/src/utils/enum.dart';
import 'package:revolt/src/utils/flags_utils.dart';

class CompleteOnboardingPayload extends Builder<Map<String, dynamic>> {
  final String username;

  CompleteOnboardingPayload({required this.username});

  @override
  Map<String, dynamic> build() => {'username': username};
}

class MessagePayload extends Builder<Map<String, dynamic>> {
  final String? content;
  final List<String>? attachments;
  final List<MessageReplyPayload>? replies;
  final List<EmbedPayload>? embeds;
  final MasqueradePayload? masquerade;

  MessagePayload({
    this.content,
    this.replies,
    this.embeds,
    this.attachments,
    this.masquerade,
  });

  @override
  Map<String, dynamic> build() {
    return {
      if (content != null && content!.isNotEmpty) 'content': content.toString(),
      'nonce': Ulid.fromNow().toString(),
      if (replies != null && replies!.isNotEmpty)
        'replies': replies!.map((r) => r.build()).toList(),
      if (embeds != null && embeds!.isNotEmpty)
        'embeds': embeds!.map((e) => e.build()).toList(),
      if (attachments != null && attachments!.isNotEmpty)
        'attachments': attachments!,
      if (masquerade != null) 'masquerade': masquerade!.build(),
    };
  }
}

class MessageReplyPayload extends Builder<Map<String, dynamic>> {
  final Ulid messageId;
  final bool mention;

  MessageReplyPayload(this.messageId, {this.mention = false});

  @override
  Map<String, dynamic> build() {
    return {
      'id': messageId.toString(),
      'mention': mention,
    };
  }
}

class MasqueradePayload extends Builder<Map<String, dynamic>> {
  final String? name;
  final Uri? avatar;

  MasqueradePayload({this.name, this.avatar});

  @override
  Map<String, dynamic> build() {
    return {
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar.toString(),
    };
  }
}

abstract class EmbedPayload extends Builder<Map<String, dynamic>> {}

class TextEmbedPayload extends EmbedPayload {
  final Uri? iconUrl;
  final Uri? url;
  final String? title;
  final String? description;
  final String? media;
  final String? colour;

  TextEmbedPayload({
    this.iconUrl,
    this.url,
    this.title,
    this.description,
    this.media,
    this.colour,
  });

  @override
  Map<String, dynamic> build() {
    return {
      'type': 'Text',
      if (iconUrl != null) 'icon_url': iconUrl.toString(),
      if (url != null) 'url': url.toString(),
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (media != null) 'media': media,
      if (colour != null) 'colour': colour,
    };
  }
}

class CreateAccountPayload extends Builder<Map<String, dynamic>> {
  final String email;
  final String password;
  final String? invite;
  final String? captcha;

  CreateAccountPayload({
    required this.email,
    required this.password,
    this.invite,
    this.captcha,
  });

  @override
  Map<String, dynamic> build() {
    return {
      'email': email,
      'password': password,
      if (invite != null) 'invite': invite!,
      if (captcha != null) 'captcha': captcha!,
    };
  }
}

class ResendVerificationPayload extends Builder<Map<String, dynamic>> {
  final String email;
  final String? captcha;

  ResendVerificationPayload({required this.email, this.captcha});

  @override
  Map<String, dynamic> build() {
    return {
      'email': email,
      if (captcha != null) 'captcha': captcha!,
    };
  }
}

class SendPasswordResetPayload extends Builder<Map<String, dynamic>> {
  final String email;
  final String? captcha;

  SendPasswordResetPayload({required this.email, this.captcha});

  @override
  Map<String, dynamic> build() {
    return {
      'email': email,
      if (captcha != null) 'captcha': captcha!,
    };
  }
}

class PasswordResetPayload extends Builder<Map<String, dynamic>> {
  final String password;
  final String token;

  PasswordResetPayload({required this.password, required this.token});

  @override
  Map<String, dynamic> build() {
    return {
      'password': password,
      'token': token,
    };
  }
}

class ChangePasswordPayload extends Builder<Map<String, dynamic>> {
  final String password;
  final String currentPassword;

  ChangePasswordPayload({
    required this.password,
    required this.currentPassword,
  });

  @override
  Map<String, dynamic> build() {
    return {
      'password': password,
      'current_password': currentPassword,
    };
  }
}

class ChangeEmailPayload extends Builder<Map<String, dynamic>> {
  final String currentPassword;
  final String email;

  ChangeEmailPayload({required this.currentPassword, required this.email});

  @override
  Map<String, dynamic> build() {
    return {
      'current_password': currentPassword,
      'email': email,
    };
  }
}

/// Login data
class LoginPayload extends Builder<Map<String, dynamic>> {
  /// Valid email address
  final String email;

  /// Password
  final String? password;

  /// Security key challenge
  final String? challenge;

  /// Session friendly name
  final String? friendlyName;

  /// Captch verification code
  final String? captcha;

  LoginPayload({
    required this.email,
    this.password,
    this.challenge,
    this.friendlyName,
    this.captcha,
  });

  @override
  Map<String, dynamic> build() {
    return {
      'email': email,
      if (password != null) 'password': password,
      if (challenge != null) 'challenge': challenge,
      if (friendlyName != null) 'friendly_name': friendlyName,
      if (captcha != null) 'captcha': captcha,
    };
  }
}

/// Edit data
class EditSessionPayload extends Builder<Map<String, dynamic>> {
  /// Session friendly name
  final String friendlyName;

  EditSessionPayload({required this.friendlyName});

  @override
  Map<String, dynamic> build() {
    return {
      'friendly_name': friendlyName,
    };
  }
}

/// Delete all active sessions query
class DeleteAllSessionsPayload extends Builder<Map<String, String>> {
  /// Whether to revoke current session too
  final bool? revokeSelf;

  DeleteAllSessionsPayload({this.revokeSelf});

  @override
  Map<String, String> build() {
    return {
      if (revokeSelf != null) 'revoke_self': revokeSelf.toString(),
    };
  }
}

/// Requested changes to user object
class EditUserPayload extends Builder<Map<String, dynamic>> {
  /// User status
  final UserStatusPayload? status;

  /// User profile data
  final UserProfileDataPayload? profile;

  /// Autumn file ID
  final String? avatar;

  /// Field to remove from user object
  final UserRemoveField? remove;

  EditUserPayload({this.status, this.profile, this.avatar, this.remove});

  @override
  Map<String, dynamic> build() {
    return {
      if (status != null) 'status': status!.build(),
      if (profile != null) 'profile': profile!.build(),
      if (avatar != null) 'avatar': avatar,
      if (remove != null) 'remove': remove!.value,
    };
  }
}

/// User status payload builder
class UserStatusPayload extends Builder<Map<String, dynamic>> {
  /// Custom status text
  final String? text;

  /// User presence
  final Presence? presence;

  UserStatusPayload({this.text, this.presence});

  @override
  Map<String, dynamic> build() {
    return {
      if (text != null) 'text': text,
      if (presence != null) 'presence': presence!.value,
    };
  }
}

/// Field to remove from user object
class UserRemoveField extends Enum<String> {
  static const avatar = UserRemoveField._create('Avatar');
  static const profileBackground = UserRemoveField._create('ProfileBackground');
  static const profileContent = UserRemoveField._create('ProfileContent');
  static const statusText = UserRemoveField._create('StatusText');

  UserRemoveField.from(String value) : super(value);
  const UserRemoveField._create(String value) : super(value);
}

/// User profile data payload builder
class UserProfileDataPayload extends Builder<Map<String, dynamic>> {
  /// Text to set as user profile description
  final String? content;

  /// Autumn background file ID
  final String? background;

  UserProfileDataPayload({this.content, this.background});

  @override
  Map<String, dynamic> build() {
    return {
      if (content != null) 'content': content,
      if (background != null) 'background': background,
    };
  }
}

/// Requested change to username
class ChangeUsernamePayload extends Builder<Map<String, dynamic>> {
  /// New username
  final String username;

  /// Current account password
  final String password;

  ChangeUsernamePayload({required this.username, required this.password});

  @override
  Map<String, dynamic> build() {
    return {
      'username': username,
      'password': password,
    };
  }
}

/// Field to remove from channel object
class ChannelRemoveField extends Enum<String> {
  static const description = ChannelRemoveField._create('Description');
  static const icon = ChannelRemoveField._create('Icon');

  ChannelRemoveField.from(String value) : super(value);
  const ChannelRemoveField._create(String value) : super(value);
}

/// Requested changes to channel object
class EditChannelPayload extends Builder<Map<String, dynamic>> {
  /// Channel name
  final String? name;

  /// Channel description
  final String? description;

  /// Channel icon
  final String? icon;

  /// Whether this channel is not safe for work
  final bool? nsfw;

  /// Field to remove from channel object
  final ChannelRemoveField? remove;

  EditChannelPayload({
    this.name,
    this.description,
    this.icon,
    this.nsfw,
    this.remove,
  });

  @override
  Map<String, dynamic> build() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (nsfw != null) 'nsfw': nsfw,
      if (remove != null) 'remove': remove!.value,
    };
  }
}

/// Group create data
class CreateGroupPayload extends Builder<Map<String, dynamic>> {
  /// Group name
  final String name;

  /// Group description
  final String? description;

  /// Array of user IDs to add to the group
  /// Note that you must be friends with them
  final List<Ulid>? users;

  /// Whether this group is not safe for work
  final bool? nsfw;

  CreateGroupPayload({
    required this.name,
    this.description,
    this.users,
    this.nsfw,
  });

  @override
  Map<String, dynamic> build() {
    return {
      'name': name,
      if (description != null) 'decription': description,
      if (users != null) 'users': users!.map((e) => e.toString()).toList(),
      if (nsfw != null) 'nsfw': nsfw,
    };
  }
}

class ChannelPermissionsBuilder extends Builder<int> {
  int _raw = 0;

  bool? viewChannel;
  bool? sendMessages;
  bool? manageMessages;
  bool? manageChannel;
  bool? voiceCall;
  bool? inviteOthers;
  bool? embedLinks;
  bool? uploadFiles;
  bool? masquerade;

  ChannelPermissionsBuilder();

  void _apply(bool? applies, int shift) =>
      _raw = FlagsUtils.apply(_raw, applies, shift);

  @override
  int build() {
    _raw = 0;

    _apply(viewChannel, 1 << 0);
    _apply(sendMessages, 1 << 1);
    _apply(manageMessages, 1 << 2);
    _apply(manageChannel, 1 << 3);
    _apply(voiceCall, 1 << 4);
    _apply(inviteOthers, 1 << 5);
    _apply(embedLinks, 1 << 6);
    _apply(uploadFiles, 1 << 7);
    _apply(masquerade, 1 << 8);

    return _raw;
  }
}

class ChannelPermissionsPayload extends Builder<Map<String, dynamic>> {
  ChannelPermissionsBuilder permissions;

  ChannelPermissionsPayload({required this.permissions});

  @override
  Map<String, dynamic> build() {
    return {'permissions': permissions.build()};
  }
}

/// Message sort direction
class MessageSortDirection extends Enum<String> {
  static const latest = MessageSortDirection._create('Latest');
  static const oldest = MessageSortDirection._create('Oldest');

  MessageSortDirection.from(String value) : super(value);
  const MessageSortDirection._create(String value) : super(value);
}

/// Messages fetch options
class FetchMessagesPayload extends Builder<Map<String, dynamic>> {
  /// Maximum number of messages to fetch. [1..100]
  /// For fetching nearby messages, this is (limit + 1)
  final int? limit;

  /// Message ID before which messages should be fetched
  final Ulid? before;

  /// Message ID after which messages should be fetched
  final Ulid? after;

  /// Message sort direction
  final MessageSortDirection direction;

  /// Message id to fetch around, this will ignore [before], [after] and [sort] options.
  /// Limits in each direction will be half of the specified limit.
  /// It also fetches the specified message ID.
  final Ulid? nearby;

  /// Whether to include user (and member, if server channel) objects.
  final bool? includeUsers;

  FetchMessagesPayload({
    this.limit,
    this.before,
    this.after,
    required this.direction,
    this.nearby,
    this.includeUsers,
  });

  @override
  Map<String, dynamic> build() {
    return {
      if (limit != null) 'limit': limit,
      if (before != null) 'before': before.toString(),
      if (after != null) 'after': after.toString(),
      'direction': direction.value,
      if (nearby != null) 'nearby': nearby.toString(),
      if (includeUsers != null) 'include_users': includeUsers,
    };
  }
}
