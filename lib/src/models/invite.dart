/// Channel invite
class ChannelInvite {
  /// Invite code
  final String code;

  ChannelInvite({required this.code});

  ChannelInvite.fromJson(Map<String, dynamic> json) : code = json['code'];
}
