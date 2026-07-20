class MediaMetadata {
  final int? width;
  final int? height;
  final String? mimeType;
  final String? device;
  final String? camera;
  final String? location;

  MediaMetadata({
    this.width,
    this.height,
    this.mimeType,
    this.device,
    this.camera,
    this.location,
  });

  factory MediaMetadata.fromJson(Map<String, dynamic> json) {
    return MediaMetadata(
      width: json['width'],
      height: json['height'],
      mimeType: json['mime_type'],
      device: json['device'],
      camera: json['camera'],
      location: json['location'],
    );
  }
}

class Media {
  final int id;
  final String shareToken;
  final String originalFilename;
  final String mediaType;
  final int sizeBytes;
  final String? uploadTime;
  final MediaMetadata? metadata;
  final bool isFavorite;

  Media({
    required this.id,
    required this.shareToken,
    required this.originalFilename,
    required this.mediaType,
    required this.sizeBytes,
    this.uploadTime,
    this.metadata,
    required this.isFavorite,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      shareToken: json['shareToken'],
      originalFilename: json['originalFilename'],
      mediaType: json['mediaType'],
      sizeBytes: json['sizeBytes'],
      uploadTime: json['uploadTime'],
      isFavorite: json['isFavorite'] ?? false,
      metadata: json['metadata'] != null
          ? MediaMetadata.fromJson(json['metadata'])
          : null,
    );
  }
}

class MediaPage {
  final List<Media> content;
  final bool last;
  final int totalElements;

  MediaPage({
    required this.content,
    required this.last,
    required this.totalElements,
  });

  factory MediaPage.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<Media> content = contentList.map((e) => Media.fromJson(e)).toList();
    return MediaPage(
      content: content,
      last: json['last'] ?? true,
      totalElements: json['totalElements'] ?? 0, // slice doesn't have totalElements usually but added for safety
    );
  }
}
