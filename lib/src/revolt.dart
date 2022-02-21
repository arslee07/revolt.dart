import 'package:revolt/api.dart';

/// A wrapper around WS and REST api which takes care on management
class Revolt {
  /// Base REST API URL
  final Uri baseUrl;

  /// Token of the bot
  final String? botToken;

  /// Session token of the user
  final String? sessionToken;

  /// Revolt WebSocket API
  final RevoltWebsocket ws;
  final RevoltRest rest;

  Revolt({
    required this.baseUrl,
    this.botToken,
    this.sessionToken,
  })  : ws = RevoltWebsocket(),
        rest = RevoltRest(
          baseUrl: baseUrl,
          botToken: botToken,
          sessionToken: sessionToken,
        );

  Future<void> connect() async {
    if (!ws.isOpen) {
      final node = await rest.queryNode();
      await ws.connect(
        token: botToken ?? sessionToken ?? '',
        baseUrl: node.ws,
      );
    }
  }

  Future<void> disconnect() async {
    await ws.disconnect();
  }

  Future<void> reconnect() async {
    await disconnect();
    await connect();
  }
}
