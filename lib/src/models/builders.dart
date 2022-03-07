import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/builder.dart';

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
