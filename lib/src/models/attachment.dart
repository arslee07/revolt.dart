import 'package:revolt/src/utils/enum.dart';
import 'package:revolt/src/utils/flags_utils.dart';

class Attachment {
  final String id;
  final FileTag tag;
  final int size;
  final String fileName;
  final String contentsType;
  final Metadata metadata;

  Attachment({
    required this.id,
    required this.tag,
    required this.size,
    required this.fileName,
    required this.contentsType,
    required this.metadata,
  });

  Attachment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        tag = FileTag.from('tag'),
        size = json['size'],
        fileName = json['filename'],
        contentsType = json['content_type'],
        metadata = Metadata.define(json['metadata']);
}

class FileTag extends Enum<String> {
  static const attachments = FileTag._create('atttachments');
  static const avatars = FileTag._create('avatars');
  static const backgrounds = FileTag._create('backgrounds');
  static const banners = FileTag._create('banners');
  static const icons = FileTag._create('icons');

  FileTag.from(String value) : super(value);
  const FileTag._create(String value) : super(value);
}

class Metadata {
  FileMetadataType type;

  Metadata({required this.type});

  Metadata.fromJson(Map<String, dynamic> raw)
      : type = FileMetadataType.from(raw['type']);

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

class FileMetadata extends Metadata {
  FileMetadata({required FileMetadataType type}) : super(type: type);
  FileMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class TextMetadata extends Metadata {
  TextMetadata({required FileMetadataType type}) : super(type: type);
  TextMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class AudioMetadata extends Metadata {
  AudioMetadata({required FileMetadataType type}) : super(type: type);
  AudioMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class ImageMetadata extends Metadata {
  final int width;
  final int height;

  ImageMetadata({
    required FileMetadataType type,
    required this.width,
    required this.height,
  }) : super(type: type);

  ImageMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        super.fromJson(json);
}

class VideoMetadata extends Metadata {
  final int width;
  final int height;

  VideoMetadata({
    required FileMetadataType type,
    required this.width,
    required this.height,
  }) : super(type: type);

  VideoMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        super.fromJson(json);
}

class UndefinedMetadata extends Metadata {
  UndefinedMetadata({required FileMetadataType type}) : super(type: type);
  UndefinedMetadata.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class FileMetadataType extends Enum<String> {
  static const file = FileMetadataType._create('File');
  static const text = FileMetadataType._create('Text');
  static const audio = FileMetadataType._create('Audio');
  static const image = FileMetadataType._create('Image');
  static const video = FileMetadataType._create('Video');
  static const undefined = FileMetadataType._create('Undefined');

  const FileMetadataType._create(String value) : super(value);
  FileMetadataType.from(String value) : super(value);
}
