import 'package:revolt/src/models/attachment.dart';
import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/enum.dart';
import 'package:revolt/src/utils/flags_utils.dart';

/// User information
class User {
  /// User ID
  final Ulid id;

  /// Username
  final String username;

  /// User avatar
  final Attachment? avatar;

  /// User profile
  final UserProfile? profile;

  /// Relationships with other known users
  /// Only present if fetching self
  final List<Relationship>? relations;

  /// User's badges
  final UserBadges? badges;

  /// User status
  final UserStatus? status;

  /// Your relationship with the user
  final RelationshipStatus? relationship;

  /// Whether the user is online
  final bool? online;

  /// User flags
  final UserFlags? flags;

  /// Bot information
  final BotInformation? bot;

  User({
    required this.id,
    required this.username,
    this.avatar,
    this.relations,
    this.badges,
    this.profile,
    this.status,
    this.relationship,
    this.online,
    this.flags,
    this.bot,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        username = json['username'],
        avatar =
            json['avatar'] == null ? null : Attachment.fromJson(json['avatar']),
        relations = json['relations'] == null
            ? null
            : [for (final e in json['relations']) Relationship.fromJson(e)],
        badges =
            json['badges'] == null ? null : UserBadges.fromRaw(json['badges']),
        profile = json['profile'] == null
            ? null
            : UserProfile.fromJson(json['profile']),
        status =
            json['status'] == null ? null : UserStatus.fromJson(json['status']),
        relationship = json['relationship'] == null
            ? null
            : RelationshipStatus.from(json['relationship']),
        online = json['online'],
        flags = json['flags'] == null ? null : UserFlags.fromRaw(json['flags']),
        bot = json['bot'] == null ? null : BotInformation.fromJson(json['bot']);
}

/// User profile
class UserProfile {
  /// Profile background
  final Attachment? background;

  /// Profile content
  final String? content;

  UserProfile({this.background, this.content});

  UserProfile.fromJson(Map<String, dynamic> json)
      : background = json['background'] == null
            ? null
            : Attachment.fromJson(json['background']),
        content = json['content'];
}

/// User status
class UserStatus {
  /// Custom status text
  final String? text;

  /// User presence
  final Presence? presence;

  UserStatus({this.text, this.presence});

  UserStatus.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        presence =
            json['presence'] == null ? null : Presence.from(json['presence']);
}

/// User presence
class Presence extends Enum<String> {
  static const busy = Presence._create('Busy');
  static const idle = Presence._create('Idle');
  static const invisible = Presence._create('Invisible');
  static const online = Presence._create('Online');

  Presence.from(String value) : super(value);
  const Presence._create(String value) : super(value);
}

/// User flags
class UserFlags {
  /// Whether the account is suspended
  final bool suspended;

  /// Whether the account is deleted
  final bool deleted;

  /// Whether the account is banned
  final bool banned;

  UserFlags({
    required this.suspended,
    required this.deleted,
    required this.banned,
  });

  UserFlags.fromRaw(int raw)
      : suspended = FlagsUtils.isApplied(raw, 1 << 0),
        deleted = FlagsUtils.isApplied(raw, 1 << 1),
        banned = FlagsUtils.isApplied(raw, 1 << 2);
}

/// Relationship with other user
class Relationship {
  /// Other user's ID
  final Ulid id;

  /// Your relationship with the user
  final RelationshipStatus status;

  Relationship({required this.id, required this.status});

  Relationship.fromJson(Map<String, dynamic> json)
      : id = Ulid(json['_id']),
        status = RelationshipStatus.from(json['status']);
}

/// Relationship with you status
class RelationshipStatus extends Enum<String> {
  static const blocked = RelationshipStatus._create('Blocked');
  static const blockedOther = RelationshipStatus._create('BlockedOther');
  static const friend = RelationshipStatus._create('Friend');
  static const incoming = RelationshipStatus._create('Incoming');
  static const none = RelationshipStatus._create('None');
  static const outgoing = RelationshipStatus._create('Outgoing');
  static const user = RelationshipStatus._create('User');

  RelationshipStatus.from(String value) : super(value);
  const RelationshipStatus._create(String value) : super(value);
}

/// User's badges
class UserBadges {
  /// Developer
  final bool developer;

  /// Translator
  final bool translator;

  /// Supporter
  final bool supporter;

  /// Responsible Disclosure
  final bool responsibleDisclosure;

  /// Founder
  final bool founder;

  /// Platform Moderation
  final bool platformModeration;

  /// Active Supporter
  final bool activeSupporter;

  /// Paw
  final bool paw;

  /// Early Adopter
  final bool earlyAdopter;

  /// Reserver Relevant Joke Badge 1 :amogus:
  final bool reservedRelevantJokeBadge1;

  UserBadges({
    required this.developer,
    required this.translator,
    required this.supporter,
    required this.responsibleDisclosure,
    required this.founder,
    required this.platformModeration,
    required this.activeSupporter,
    required this.paw,
    required this.earlyAdopter,
    required this.reservedRelevantJokeBadge1,
  });

  UserBadges.fromRaw(int raw)
      : developer = FlagsUtils.isApplied(raw, 1 << 0),
        translator = FlagsUtils.isApplied(raw, 1 << 1),
        supporter = FlagsUtils.isApplied(raw, 1 << 2),
        responsibleDisclosure = FlagsUtils.isApplied(raw, 1 << 3),
        founder = FlagsUtils.isApplied(raw, 1 << 4),
        platformModeration = FlagsUtils.isApplied(raw, 1 << 5),
        activeSupporter = FlagsUtils.isApplied(raw, 1 << 6),
        paw = FlagsUtils.isApplied(raw, 1 << 7),
        earlyAdopter = FlagsUtils.isApplied(raw, 1 << 8),
        reservedRelevantJokeBadge1 = FlagsUtils.isApplied(raw, 1 << 9);
}

/// Bot information
class BotInformation {
  /// The user ID of the owner of this bot
  final Ulid owner;

  BotInformation({required this.owner});

  BotInformation.fromJson(Map<String, dynamic> json)
      : owner = Ulid(json['owner']);
}
