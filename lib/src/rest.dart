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
    CompleteOnboardingBuilder completeOnboardingBuilder,
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
    required CreateAccountBuilder builder,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/create',
      body: builder.build(),
    );
  }

  /// Resend account creation verification email.
  Future<void> resendVerfication({
    required ResendVerificationBuilder builder,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/reverify',
      body: builder.build(),
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
    required SendPasswordResetBuilder builder,
  }) async {
    await fetchRaw(
      'POST',
      '/auth/account/reset_password',
      body: builder.build(),
    );
  }

  /// Conirm password reset.
  Future<void> passwordReset({
    required PasswordResetBuilder builder,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/reset_password',
      body: builder.build(),
    );
  }

  /// Change account password.
  Future<void> changePassword({
    required ChangePasswordBuilder builder,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/change/password',
      body: builder.build(),
    );
  }

  /// Change account email.
  Future<void> changeEmail({
    required ChangeEmailBuilder builder,
  }) async {
    await fetchRaw(
      'PATCH',
      '/auth/account/change/email',
      body: builder.build(),
    );
  }

  // --- Session ---

  // --- User Information ---

  /// Retrieve your user information.
  Future<User> fetchSelf() async {
    return User.fromJson(await fetchRaw('GET', '/users/@me'));
  }

  // --- Direct Messaging ---

  // --- Relationships ---

  // --- Channel Information ---

  /// Retreive a channel.
  Future<T> fetchChannel<T extends Channel>({required Ulid channelId}) async {
    return Channel.define(await fetchRaw('GET', '/channels/$channelId')) as T;
  }

  // --- Channel Invites ---

  // --- Channel Permissions ---

  // --- Messaging ---

  /// Send message to specified channel.
  Future<Message> sendMessage({
    required Ulid channelId,
    required MessageBuilder message,
  }) async {
    return Message.fromJson(
      await fetchRaw(
        'POST',
        '/channels/$channelId/messages',
        body: message.build(),
      ),
    );
  }

  /// Retreive a message.
  Future<Message> fetchMessage({
    required Ulid channelId,
    required Ulid messageId,
  }) async {
    return Message.fromJson(
      await fetchRaw('GET', '/channels/$channelId/messages/$messageId'),
    );
  }

  // --- Groups ---

  // --- Voice ---

  // --- Server Information ---

  /// Retrieve a server.
  Future<Server> fetchServer({required Ulid serverId}) async {
    return Server.fromJson(await fetchRaw('GET', '/servers/$serverId'));
  }

  // --- Server Members ---

  // --- Server Permissions ---

  // --- Bots ---

  // --- Invites ---

  // --- Sync ---

  // --- Web Push ---
}
