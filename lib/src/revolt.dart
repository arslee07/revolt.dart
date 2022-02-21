import 'package:revolt/api.dart';

/// A wrapper around WS and REST api which takes care on management
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

  /// Revolt WebSocket API
  final RevoltWebsocket ws;
  final RevoltRest rest;

  Revolt({
    required this.baseRestUrl,
    required this.baseWsUrl,
    this.botToken,
    this.sessionToken,
  })  : ws = RevoltWebsocket(),
        rest = RevoltRest(
          baseUrl: baseRestUrl,
          botToken: botToken,
          sessionToken: sessionToken,
        );

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
}
