import 'package:revolt/revolt.dart';

void main() async {
  final client = Revolt(
    baseRestUrl: Uri.parse('https://api.revolt.chat'),
    botToken: 'le token',
  );

  final user = await client.fetchSelf();
  print(user.username);
}
