import 'dart:convert';
import 'dart:io';

import 'package:revolt/models.dart';

class RevoltRest {
  final String? botToken;
  final String? sessionToken;
  final Uri baseUrl;

  RevoltRest({required this.baseUrl, this.botToken, this.sessionToken});

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
        scheme: baseUrl.scheme,
        host: baseUrl.host,
        port: baseUrl.port,
        path: baseUrl.path + path,
        queryParameters: query.isEmpty ? null : query,
      ),
    );

    req.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');

    if (sessionToken != null) {
      req.headers.set('x-session-token', sessionToken!);
    } else if (botToken != null) {
      req.headers.set('x-bot-token', botToken!);
    }

    req.headers.contentLength = utf8.encode(jsonEncode(body)).length;
    req.add(utf8.encode(jsonEncode(body)));

    final res = await req.close();
    final data = await utf8.decodeStream(res);
    c.close();

    if (!(res.statusCode >= 200 && res.statusCode <= 299)) {
      throw res.statusCode;
    }

    if (data.isNotEmpty) return json.decode(data);
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
    CompleteOnboardingPayload completeOnboardingBuilder,
  ) async {
    await fetchRaw(
      'POST',
      '/onboard/complete',
      body: completeOnboardingBuilder.build(),
    );
  }

  // --- Account ---

  /// Fetch account information.
  Future<AccountInfo> fetchAccount() async {
    return AccountInfo.fromJson(
      await fetchRaw(
        'GET',
        '/auth/account',
      ),
    );
  }

  /// Create a new account.
  Future<void> createAccount({
    required CreateAccountPayload payload,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/create',
      body: payload.build(),
    );
  }

  /// Resend account creation verification email.
  Future<void> resendVerfication({
    required ResendVerificationPayload payload,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/reverify',
      body: payload.build(),
    );
  }

  /// Verify email with verification code.
  Future<void> verifyEmail({
    required String code,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/verify/$code',
    );
  }

  /// Send password reset email.
  Future<void> sendPasswordReset({
    required SendPasswordResetPayload payload,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/reset_password',
      body: payload.build(),
    );
  }

  /// Conirm password reset.
  Future<void> passwordReset({
    required PasswordResetPayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/reset_password',
      body: payload.build(),
    );
  }

  /// Change account password.
  Future<void> changePassword({
    required ChangePasswordPayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/change/password',
      body: payload.build(),
    );
  }

  /// Change account email.
  Future<void> changeEmail({
    required ChangeEmailPayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/change/email',
      body: payload.build(),
    );
  }

  // --- Session ---

  /// Login to an account.
  Future<Session> login({
    required LoginPayload payload,
  }) async {
    return Session.fromJson(
      await fetchRaw(
        'POST',
        '/auth/session/login',
        body: payload.build(),
      ),
    );
  }

  /// Close current session.
  Future<void> logout() async {
    await fetchRaw(
      'POST',
      '/auth/session/logout',
    );
  }

  /// Edit session information.
  Future<void> editSession({
    required Ulid sessionId,
    required EditSessionPayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/session/$sessionId',
      body: payload.build(),
    );
  }

  /// Delete a specific session.
  Future<void> deleteSession({
    required Ulid sessionId,
  }) async {
    await fetchRaw(
      'DELETE',
      '/auth/session/$sessionId',
    );
  }

  /// Fetch all sessions.
  Future<List<PartialSession>> fetchSessions() async {
    return [
      for (final e in await fetchRaw(
        'GET',
        '/auth/session/all',
      ))
        PartialSession.fromJson(e)
    ];
  }

  /// Delete all active sessions.
  Future<void> deleteAllSessions({
    required DeleteAllSessionsPayload payload,
  }) async {
    await fetchRaw(
      'DELETE',
      '/auth/session/all',
      query: payload.build(),
    );
  }

  // --- User Information ---

  /// Retreive a user's information.
  Future<User> fetchUser({
    required Ulid userId,
  }) async {
    return User.fromJson(
      await fetchRaw(
        'GET',
        '/users/$userId',
      ),
    );
  }

  /// Edit your user object.
  Future<void> editUser({
    required EditUserPayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/users/@me',
      body: payload.build(),
    );
  }

  /// Retrieve your user information.
  Future<User> fetchSelf() async {
    return User.fromJson(
      await fetchRaw(
        'GET',
        '/users/@me',
      ),
    );
  }

  /// Change your username.
  Future<void> changeUsername({
    required ChangeUsernamePayload payload,
  }) async {
    await fetchRaw(
      'PATCH',
      '/users/@me/username',
      body: payload.build(),
    );
  }

  /// Retreive a user's profile data.
  Future<UserProfile> fetchUserProfile({
    required Ulid userId,
  }) async {
    return UserProfile.fromJson(
      await fetchRaw(
        'GET',
        '/users/$userId/profile',
      ),
    );
  }

  /// This returns a default avatar based on the given id.
  // FIXME
  // Future<String> fetchDefaultAvatar({
  //   required Ulid userId,
  // }) async {
  //   return await fetchRaw(
  //     'GET',
  //     '/users/$userId/default_avatar',
  //   ) as String;
  // }

  Future<MutualFriendsAndServers> fetchMutualFriendsAndServers({
    required Ulid userId,
  }) async {
    return MutualFriendsAndServers.fromJson(
      await fetchRaw(
        'GET',
        '/users/$userId/mutual',
      ),
    );
  }

  // --- Direct Messaging ---

  /// Fetch direct messages, including any DM and group DM conversations.
  Future<List<Channel>> fetchDirectMessageChannels() async {
    return [
      for (final e in await fetchRaw(
        'GET',
        '/users/dms',
      ))
        Channel.define(e),
    ];
  }
  
  /// Open a DM with another user.
  Future<DirectMessageChannel> openDiectMessage({
    required Ulid userId,
  }) async {
    return DirectMessageChannel.fromJson(
      await fetchRaw(
        'GET',
        '/users/$userId/dm',
      ),
    );
  }

  // --- Relationships ---

  // --- Channel Information ---

  /// Retreive a channel.
  Future<T> fetchChannel<T extends Channel>({
    required Ulid channelId,
  }) async {
    return Channel.define(
      await fetchRaw(
        'GET',
        '/channels/$channelId',
      ),
    ) as T;
  }

  // --- Channel Invites ---

  // --- Channel Permissions ---

  // --- Messaging ---

  /// Send message to specified channel.
  Future<Message> sendMessage({
    required Ulid channelId,
    required MessagePayload payload,
  }) async {
    return Message.fromJson(
      await fetchRaw(
        'POST',
        '/channels/$channelId/messages',
        body: payload.build(),
      ),
    );
  }

  /// Retreive a message.
  Future<Message> fetchMessage({
    required Ulid channelId,
    required Ulid messageId,
  }) async {
    return Message.fromJson(
      await fetchRaw(
        'GET',
        '/channels/$channelId/messages/$messageId',
      ),
    );
  }

  // --- Groups ---

  // --- Voice ---

  // --- Server Information ---

  /// Retrieve a server.
  Future<Server> fetchServer({
    required Ulid serverId,
  }) async {
    return Server.fromJson(
      await fetchRaw(
        'GET',
        '/servers/$serverId',
      ),
    );
  }

  // --- Server Members ---

  // --- Server Permissions ---

  // --- Bots ---

  // --- Invites ---

  // --- Sync ---

  // --- Web Push ---
}
