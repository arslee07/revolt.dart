class NodeInfo {
  /// Revolt API version string
  final String revolt;

  /// Available features exposed by the API
  final NodeFeatures features;

  /// WebSocket URL
  final Uri ws;

  /// URL to web app associated with this instance
  final Uri app;

  /// Web Push VAPID key
  final String vapid;

  NodeInfo({
    required this.revolt,
    required this.features,
    required this.ws,
    required this.app,
    required this.vapid,
  });

  NodeInfo.fromJson(Map<String, dynamic> json)
      : revolt = json['revolt'],
        features = NodeFeatures.fromJson(json['features']),
        ws = Uri.parse(json['ws']),
        app = Uri.parse(json['app']),
        vapid = json['vapid'];
}

/// Available features exposed by the API
class NodeFeatures {
  /// hCaptcha options
  final Captcha captcha;

  /// Whether email verification is enabled
  final bool email;

  /// Whether an invite code is required to register
  final bool inviteOnly;

  /// Autumn (file server) options
  final Autumn autumn;

  /// January (proxy server) options
  final January january;

  /// Legacy voice server options
  final Voso voso;

  NodeFeatures({
    required this.captcha,
    required this.email,
    required this.inviteOnly,
    required this.autumn,
    required this.january,
    required this.voso,
  });

  NodeFeatures.fromJson(Map<String, dynamic> json)
      : captcha = Captcha.fromJson(json['captcha']),
        email = json['email'],
        inviteOnly = json['invite_only'],
        autumn = Autumn.fromJson(json['autumn']),
        january = January.fromJson(json['january']),
        voso = Voso.fromJson(json['voso']);
}

/// hCaptcha options
class Captcha {
  /// Whether hCaptcha is enabled
  final bool enabled;

  /// hCaptcha site key
  final String key;

  Captcha({required this.enabled, required this.key});

  Captcha.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] as bool,
        key = json['key'] as String;
}

/// Autumn (file server) options
class Autumn {
  /// Whether file uploads are enabled
  final bool enabled;

  /// Autumn API URL
  final Uri url;

  Autumn({required this.enabled, required this.url});

  Autumn.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] as bool,
        url = Uri.parse(json['url'] as String);
}

/// January (proxy server) options
class January {
  /// Whether link embeds are enabled
  final bool enabled;

  /// January API URL
  final Uri url;

  January({required this.enabled, required this.url});

  January.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] as bool,
        url = Uri.parse(json['url'] as String);
}

/// Legacy voice server options
class Voso {
  /// Whether voice is available (using voso)
  final bool enabled;

  /// Voso API URL
  final Uri url;

  /// Voso WebSocket URL
  final Uri ws;

  Voso({required this.enabled, required this.url, required this.ws});

  Voso.fromJson(Map<String, dynamic> json)
      : enabled = json['enabled'] as bool,
        url = Uri.parse(json['url'] as String),
        ws = Uri.parse(json['ws'] as String);
}
