import 'package:revolt/src/utils/flags_utils.dart';

class ChannelPermissions {
  final bool viewChannel;
  final bool sendMessages;
  final bool manageMessages;
  final bool manageChannel;
  final bool voiceCall;
  final bool inviteOthers;
  final bool embedLinks;
  final bool uploadFiles;
  final bool masquerade;

  ChannelPermissions({
    required this.viewChannel,
    required this.sendMessages,
    required this.manageMessages,
    required this.manageChannel,
    required this.voiceCall,
    required this.inviteOthers,
    required this.embedLinks,
    required this.uploadFiles,
    required this.masquerade,
  });

  ChannelPermissions.fromRaw(int raw)
      : viewChannel = FlagsUtils.isApplied(raw, 1 << 0),
        sendMessages = FlagsUtils.isApplied(raw, 1 << 1),
        manageMessages = FlagsUtils.isApplied(raw, 1 << 2),
        manageChannel = FlagsUtils.isApplied(raw, 1 << 3),
        voiceCall = FlagsUtils.isApplied(raw, 1 << 4),
        inviteOthers = FlagsUtils.isApplied(raw, 1 << 5),
        embedLinks = FlagsUtils.isApplied(raw, 1 << 6),
        uploadFiles = FlagsUtils.isApplied(raw, 1 << 7),
        masquerade = FlagsUtils.isApplied(raw, 1 << 8);
}

class ServerPermissions {
  final bool viewServer;
  final bool manageRoles;
  final bool manageChannels;
  final bool manageServer;
  final bool kickMembers;
  final bool banMembers;
  final bool changeNickname;
  final bool manageNicknames;
  final bool changeAvatar;
  final bool removeAvatars;

  ServerPermissions({
    required this.viewServer,
    required this.manageRoles,
    required this.manageChannels,
    required this.manageServer,
    required this.kickMembers,
    required this.banMembers,
    required this.changeNickname,
    required this.manageNicknames,
    required this.changeAvatar,
    required this.removeAvatars,
  });

  ServerPermissions.fromRaw(int raw)
      : viewServer = FlagsUtils.isApplied(raw, 1 << 0),
        manageRoles = FlagsUtils.isApplied(raw, 1 << 1),
        manageChannels = FlagsUtils.isApplied(raw, 1 << 2),
        manageServer = FlagsUtils.isApplied(raw, 1 << 3),
        kickMembers = FlagsUtils.isApplied(raw, 1 << 4),
        banMembers = FlagsUtils.isApplied(raw, 1 << 5),
        changeNickname = FlagsUtils.isApplied(raw, 1 << 12),
        manageNicknames = FlagsUtils.isApplied(raw, 1 << 13),
        changeAvatar = FlagsUtils.isApplied(raw, 1 << 14),
        removeAvatars = FlagsUtils.isApplied(raw, 1 << 15);
}
