import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/builder.dart';

class CompleteOnboardingBuilder extends Builder<Map<String, dynamic>> {
  final String username;

  CompleteOnboardingBuilder({required this.username});

  @override
  Map<String, dynamic> build() => {'username': username};
}

class MessageBuilder extends Builder<Map<String, dynamic>> {
  final String? content;
  final List<String>? attachments;
  final List<MessageReplyBuilder>? replies;
  final List<EmbedBuilder>? embeds;
  final MasqueradeBuilder? masquerade;

  MessageBuilder({
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

class MessageReplyBuilder extends Builder<Map<String, dynamic>> {
  final Ulid messageId;
  final bool mention;

  MessageReplyBuilder(this.messageId, {this.mention = false});

  @override
  Map<String, dynamic> build() {
    return {
      'id': messageId.toString(),
      'mention': mention,
    };
  }
}

class MasqueradeBuilder extends Builder<Map<String, dynamic>> {
  final String? name;
  final Uri? avatar;

  MasqueradeBuilder({this.name, this.avatar});

  @override
  Map<String, dynamic> build() {
    return {
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar.toString(),
    };
  }
}

abstract class EmbedBuilder extends Builder<Map<String, dynamic>> {}

class TextEmbedBuilder extends EmbedBuilder {
  final Uri? iconUrl;
  final Uri? url;
  final String? title;
  final String? description;
  final String? media;
  final String? colour;

  TextEmbedBuilder({
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
