import 'package:revolt/src/utils/enum.dart';
import 'package:revolt/src/utils/flags_utils.dart';

/// Attachment information
class Attachment {
  /// Attachment ID
  final String id;

  /// Attachment tag
  final AttachmentTag tag;

  /// File size (in bytes)
  final int size;

  /// File name
  final String fileName;

  /// Content type
  final String contentType;

  /// Metadata
  final Metadata metadata;

  Attachment({
    required this.id,
    required this.tag,
    required this.size,
    required this.fileName,
    required this.contentType,
    required this.metadata,
  });

  Attachment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        tag = AttachmentTag.from('tag'),
        size = json['size'],
        fileName = json['filename'],
        contentType = json['content_type'],
        metadata = Metadata.define(json['metadata']);
}

/// Attachment tag
class AttachmentTag extends Enum<String> {
  static const attachments = AttachmentTag._create('atttachments');
  static const avatars = AttachmentTag._create('avatars');
  static const backgrounds = AttachmentTag._create('backgrounds');
  static const banners = AttachmentTag._create('banners');
  static const icons = AttachmentTag._create('icons');

  AttachmentTag.from(String value) : super(value);
  const AttachmentTag._create(String value) : super(value);
}

/// Attachment metadata
class Metadata {
  /// Attachment metadata type
  AttachmentMetadataType type;

  Metadata({required this.type});

  Metadata.fromJson(Map<String, dynamic> raw)
      : type = AttachmentMetadataType.from(raw['type']);

  factory Metadata.define(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'File':
        return FileMetadata.fromJson(json);
      case 'Text':
        return TextMetadata.fromJson(json);
      case 'Audio':
        return AudioMetadata.fromJson(json);
      case 'Image':
        return ImageMetadata.fromJson(json);
      case 'Video':
        return VideoMetadata.fromJson(json);
      default:
        return UndefinedMetadata.fromJson(json);
    }
  }
}

/// File metadata
class FileMetadata extends Metadata {
  FileMetadata({required AttachmentMetadataType type}) : super(type: type);
  FileMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Text metadata
class TextMetadata extends Metadata {
  TextMetadata({required AttachmentMetadataType type}) : super(type: type);
  TextMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Audio metadata
class AudioMetadata extends Metadata {
  AudioMetadata({required AttachmentMetadataType type}) : super(type: type);
  AudioMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Image metadata
class ImageMetadata extends Metadata {
  /// Image width
  final int width;

  /// Image height
  final int height;

  ImageMetadata({
    required AttachmentMetadataType type,
    required this.width,
    required this.height,
  }) : super(type: type);

  ImageMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        super.fromJson(json);
}

/// Video metadata
class VideoMetadata extends Metadata {
  /// Video width
  final int width;

  /// Video height
  final int height;

  VideoMetadata({
    required AttachmentMetadataType type,
    required this.width,
    required this.height,
  }) : super(type: type);

  VideoMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        super.fromJson(json);
}

/// Undefined metadata
class UndefinedMetadata extends Metadata {
  UndefinedMetadata({required AttachmentMetadataType type}) : super(type: type);
  UndefinedMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// Attachment metadata type
class AttachmentMetadataType extends Enum<String> {
  static const file = AttachmentMetadataType._create('File');
  static const text = AttachmentMetadataType._create('Text');
  static const audio = AttachmentMetadataType._create('Audio');
  static const image = AttachmentMetadataType._create('Image');
  static const video = AttachmentMetadataType._create('Video');
  static const undefined = AttachmentMetadataType._create('Undefined');

  const AttachmentMetadataType._create(String value) : super(value);
  AttachmentMetadataType.from(String value) : super(value);
}
