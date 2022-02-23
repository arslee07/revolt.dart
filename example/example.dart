import 'dart:math';

import 'package:revolt/revolt.dart';

void main() async {
  final client = Revolt(
    baseUrl: Uri.parse('https://api.revolt.chat'),
    botToken: '',
  );

  client.ws.onMessage.stream.where((m) => m.content is String)
    ..where((m) => m.content.startsWith('a.ping')).listen(
      (e) async {
        await client.rest.sendMessage(
          channelId: e.channel,
          message: MessageBuilder.reply(
            'Pong! :amogus:',
            replies: [MessageReplyBuilder(e.id, mention: true)],
          ),
        );
      },
    )
    ..where((m) => m.content.startsWith('a.random')).listen(
      (e) async {
        await client.rest.sendMessage(
          channelId: e.channel,
          message: MessageBuilder.reply(
            Random().nextInt(1000).toString(),
            replies: [MessageReplyBuilder(e.id, mention: true)],
          ),
        );
      },
    );

  await client.connect();
}
