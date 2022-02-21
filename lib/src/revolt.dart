import 'dart:convert';
import 'dart:io';

import 'package:revolt/src/models/builders.dart';
import 'package:revolt/src/models/node_info.dart';
import 'package:revolt/src/models/onboarding.dart';
import 'package:revolt/src/models/user.dart';
import 'package:revolt/src/ws.dart';

class Revolt {
  /// Base REST API URL
  final Uri baseRestUrl;

  // TODO: fetch ws url automatically
  /// Base WebSocket URL
  final Uri baseWsUrl;

  /// Token of the bot
  final String? botToken;

  /// Session token of the user
  final String? sessionToken;

  final RevoltWebsocket ws;

  Revolt({
    required this.baseRestUrl,
    required this.baseWsUrl,
    this.botToken,
    this.sessionToken,
  }) : ws = RevoltWebsocket();

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

  Future<void> connect() async {
    if (!ws.isOpen) {
      await ws.connect(
        token: botToken ?? sessionToken ?? '',
        baseUrl: baseWsUrl,
      );
    }
  }

  Future<void> disconnect() async {
    await ws.disconnect();
  }

  Future<void> reconnect() async {
    await ws.disconnect();
    await ws.connect(token: botToken ?? sessionToken ?? '', baseUrl: baseWsUrl);
  }

  // --- Core ---

  /// Fetch information about which features are enabled on the remote node.
  Future<NodeInfo> queryNode() async {
    return NodeInfo.fromJson(await fetchRaw('GET', '/'));
  }

  // --- Onboarding ---

  /// This will tell you whether the current account requires onboarding or whether you can continue to send requests as usual.
  /// You may skip calling this if you're restoring an existing session.
  Future<OnboardingInformation> checkOnboardingStatus() async {
    return OnboardingInformation.fromJson(
      await fetchRaw('GET', '/onboard/hello'),
    );
  }

  /// Set a new username, complete onboarding and allow a user to start using Revolt.
  Future<void> completeOnboarding(
    CompleteOnboardingBuilder completeOnboardingBuilder,
  ) async {
    await fetchRaw(
      'POST',
      '/onboard/complete',
      body: completeOnboardingBuilder.build(),
    );
  }

  // --- Auth ---

  // --- Account ---

  // --- Session ---

  // --- User Information ---

  /// Retrieve your user information.
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
