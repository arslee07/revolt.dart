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
      {'type': 'Ping', 'data': DateTime.now().millisecondsSinceEpoch},
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
  }

  Future<void> disconnect() async {
    await close();
  }

  Future<void> open(Uri baseUrl) async {
    _ws = await WebSocket.connect(baseUrl.toString());
    _ws!.listen(_handle);
  }

  Future<void> close() async {
    _heartbeat?.cancel();
    await _ws?.close();

    _ws = null;
    _heartbeat = null;
  }
}
