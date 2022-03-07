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
          payload: MessagePayload(
            content: 'Pong! :amogus:',
            replies: [MessageReplyPayload(e.id)],
          ),
        );
      },
    )
    ..where((m) => m.content.startsWith('a.random')).listen(
      (e) async {
        await client.rest.sendMessage(
          channelId: e.channel,
          payload: MessagePayload(
            content: Random().nextInt(1000).toString(),
            replies: [MessageReplyPayload(e.id)],
          ),
        );
      },
    )
    ..where((m) => m.content.startsWith('a.fullmessage')).listen(
      (e) async {
        await client.rest.sendMessage(
          channelId: e.channel,
          payload: MessagePayload(
            content: 'Full message test :amogus:',
            replies: [MessageReplyPayload(e.id)],
            embeds: [
              TextEmbedPayload(title: 'among us', description: ':amogus:'),
            ],
            masquerade: MasqueradePayload(
              name: 'among_us_gamer_6969',
              avatar: Uri.parse(
                'http://www.rw-designer.com/icon-image/21508-256x256x32.png',
              ),
            ),
          ),
        );
      },
    );

  await client.connect();
}
