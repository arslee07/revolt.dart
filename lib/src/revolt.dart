import 'dart:convert';
import 'dart:io';

import 'package:revolt/src/models/user.dart';

class Revolt {
  /// Base REST API URL
  final Uri baseRestUrl;

  /// Token of the bot
  final String? botToken;

  /// Session token of the user
  final String? sessionToken;

  Revolt({
    required this.baseRestUrl,
    this.botToken,
    this.sessionToken,
  });

  /// Fetch raw JSON content.
  /// Can return [null], [List<dynamic>] or [Map<String, dynamic>]
  Future<dynamic> fetchRaw(
    String method,
    String path, {
    Map<String, dynamic> body = const {},
    Map<String, String> query = const {},
  }) async {
    final c = HttpClient();
    final req = await c.openUrl(
      method,
      Uri(
        scheme: baseRestUrl.scheme,
        host: baseRestUrl.host,
        port: baseRestUrl.port,
        path: baseRestUrl.path + path,
        queryParameters: query,
      ),
    );

    req.headers.add('content-type', 'application/json');

    if (sessionToken != null) {
      req.headers.add('x-session-token', sessionToken!);
    } else if (botToken != null) {
      req.headers.add('x-bot-token', botToken!);
    }

    if (method != 'GET') {
      req.headers.add('content-length', utf8.encode(jsonEncode(body)).length);
      req.write(utf8.encode(jsonEncode(body)));
    }

    final res = await req.close();
    final data = await res.transform(utf8.decoder).join();
    c.close();

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw body;
    }

    if (data.isNotEmpty) return json.decode(data);
  }

  // --- Core ---

  // --- Onboarding ---

  // --- Auth ---

  // --- Account ---

  // --- Session ---

  // --- User Information ---

  /// Retrieve your user information
  Future<User> fetchSelf() async {
    return User.fromJson(await fetchRaw('GET', '/users/@me'));
  }

  // --- Direct Messaging ---

  // --- Relationships ---

  // --- Channel Information ---

  // --- Channel Invites ---

  // --- Channel Permissions ---

  // --- Messaging ---

  // --- Groups ---

  // --- Voice ---

  // --- Server Information ---

  // --- Server Members ---

  // --- Server Permissions ---

  // --- Bots ---

  // --- Invites ---

  // --- Sync ---

  // --- Web Push ---
}
