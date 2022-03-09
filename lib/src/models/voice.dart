/// Voice join data
class VoiceJoinData {
  /// Voso (vortext) token
  final String token;

  VoiceJoinData({required this.token});

  VoiceJoinData.fromJson(Map<String, dynamic> json) : token = json['token'];
}
