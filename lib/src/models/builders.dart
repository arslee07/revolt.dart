import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/builder.dart';

class CompleteOnboardingBuilder extends Builder<Map<String, dynamic>> {
  final String username;

  CompleteOnboardingBuilder({required this.username});

  @override
  Map<String, dynamic> build() => {'username': username};
}

// TODO: implement attachments
class MessageBuilder extends Builder<Map<String, dynamic>> {
  final String? content;
  final List<MessageReplyBuilder>? replies;
  final List<EmbedBuilder>? embeds;

  MessageBuilder({this.content, this.replies, this.embeds});

  @override
  Map<String, dynamic> build() {
    return {
      if (content != null && content!.isNotEmpty) 'content': content.toString(),
      'nonce': Ulid.fromNow().toString(),
      if (replies != null && replies!.isNotEmpty)
        'replies': replies!.map((r) => r.build()).toList(),
      if (embeds != null && embeds!.isNotEmpty)
        'embeds': embeds!.map((e) => e.build()).toList(),
    };
  }
}

class MessageReplyBuilder extends Builder<Map<String, dynamic>> {
  Ulid messageId;
  bool mention;

  MessageReplyBuilder(this.messageId, {this.mention = false});

  @override
  Map<String, dynamic> build() {
    return {
      'id': messageId.toString(),
      'mention': mention,
    };
  }
}

abstract class EmbedBuilder extends Builder<Map<String, dynamic>> {}

class TextEmbedBuilder extends EmbedBuilder {
  Uri? iconUrl;
  Uri? url;
  String? title;
  String? description;
  String? media;
  String? colour;

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
