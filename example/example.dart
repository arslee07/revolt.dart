import 'package:revolt/revolt.dart';
import 'package:revolt/src/ws.dart';

void main() async {
  final client = Revolt(
    baseRestUrl: Uri.parse('https://api.revolt.chat'),
    baseWsUrl: Uri.parse('wss://ws.revolt.chat'),
    botToken: '',
  );

  client.ws.onRawEvent.stream.listen(print);

  await client.connect();

  final user = await client.fetchSelf();
  print(user.username);
}
