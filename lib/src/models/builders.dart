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
  String? content;
  List<MessageReplyBuilder>? replies;

  MessageBuilder();

  factory MessageBuilder.content(String content) {
    return MessageBuilder()..content = content;
  }

  factory MessageBuilder.reply(
    String content, {
    required List<MessageReplyBuilder> replies,
  }) {
    return MessageBuilder()..replies = replies;
  }

  @override
  Map<String, dynamic> build() {
    return {
      if (content != null && content!.isNotEmpty) 'content': content.toString(),
      'nonce': Ulid.fromNow().toString(),
      if (replies != null && replies!.isNotEmpty)
        'replies': replies!.map((r) => r.build()).toList()
    };
  }
}

class MessageReplyBuilder extends Builder<Map<String, dynamic>> {
  Ulid messageId;
  bool shouldMention;

  MessageReplyBuilder(this.messageId, {this.shouldMention = false});

  @override
  Map<String, dynamic> build() {
    return {
      'id': messageId.toString(),
      'mention': shouldMention,
    };
  }
}
