import 'dart:async';
import 'dart:convert';
import 'dart:io';

class RevoltWebsocket {
  WebSocket? _ws;
  Timer? _heartbeat;

  bool get isOpen => _ws != null;

  final StreamController<dynamic> onRawEvent = StreamController.broadcast();

  RevoltWebsocket();

  void _handle(dynamic data) {
    onRawEvent.add(data);
  }

  Future<void> sendPing() async {
    _ws!.add(jsonEncode(
      {'type': 'Ping', 'data': 0},
    ));
  }

  Future<void> sendAuth(String token) async {
    _ws!.add(jsonEncode(
      {'type': 'Authenticate', 'token': token},
    ));
  }

  Future<void> connect({
    required String token,
    required Uri baseUrl,
    bool autoPing = true,
    bool autoAuth = true,
    bool autoReconnect = true,
  }) async {
    await open(baseUrl);
    if (autoAuth) {
      await sendAuth(token);
    }
    if (autoPing) {
      _heartbeat = Timer.periodic(
        Duration(seconds: 10),
        (timer) {
          sendPing();
        },
      );
    }
    if (autoReconnect) {
      _ws?.done.then((_) async {
        await disconnect();
        await connect(
          baseUrl: baseUrl,
          token: token,
          autoPing: autoPing,
          autoAuth: autoAuth,
          autoReconnect: autoReconnect,
        );
      });
    }
  }

  Future<void> disconnect() async {
    await close();
  }

  Future<void> open(Uri baseUrl) async {
    _ws = await WebSocket.connect(baseUrl.toString());
    _ws!.listen(_handle, cancelOnError: true);
  }

  Future<void> close() async {
    _heartbeat?.cancel();
    await _ws?.close();

    _ws = null;
    _heartbeat = null;
  }
}
