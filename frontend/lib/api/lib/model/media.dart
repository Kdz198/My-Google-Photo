//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Media {
  /// Returns a new [Media] instance.
  Media({
    this.id,
    this.shareToken,
    this.originalFilename,
    this.storagePath,
    this.thumbnailPath,
    this.mediaType,
    this.sizeBytes,
    this.creationTime,
    this.uploadTime,
    this.metadata,
    this.isFavorite,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? shareToken;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? originalFilename;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? storagePath;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? thumbnailPath;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mediaType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? sizeBytes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? creationTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? uploadTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MediaMetadata? metadata;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isFavorite;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Media &&
    other.id == id &&
    other.shareToken == shareToken &&
    other.originalFilename == originalFilename &&
    other.storagePath == storagePath &&
    other.thumbnailPath == thumbnailPath &&
    other.mediaType == mediaType &&
    other.sizeBytes == sizeBytes &&
    other.creationTime == creationTime &&
    other.uploadTime == uploadTime &&
    other.metadata == metadata &&
    other.isFavorite == isFavorite;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (shareToken == null ? 0 : shareToken!.hashCode) +
    (originalFilename == null ? 0 : originalFilename!.hashCode) +
    (storagePath == null ? 0 : storagePath!.hashCode) +
    (thumbnailPath == null ? 0 : thumbnailPath!.hashCode) +
    (mediaType == null ? 0 : mediaType!.hashCode) +
    (sizeBytes == null ? 0 : sizeBytes!.hashCode) +
    (creationTime == null ? 0 : creationTime!.hashCode) +
    (uploadTime == null ? 0 : uploadTime!.hashCode) +
    (metadata == null ? 0 : metadata!.hashCode) +
    (isFavorite == null ? 0 : isFavorite!.hashCode);

  @override
  String toString() => 'Media[id=$id, shareToken=$shareToken, originalFilename=$originalFilename, storagePath=$storagePath, thumbnailPath=$thumbnailPath, mediaType=$mediaType, sizeBytes=$sizeBytes, creationTime=$creationTime, uploadTime=$uploadTime, metadata=$metadata, isFavorite=$isFavorite]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.shareToken != null) {
      json[r'shareToken'] = this.shareToken;
    } else {
      json[r'shareToken'] = null;
    }
    if (this.originalFilename != null) {
      json[r'originalFilename'] = this.originalFilename;
    } else {
      json[r'originalFilename'] = null;
    }
    if (this.storagePath != null) {
      json[r'storagePath'] = this.storagePath;
    } else {
      json[r'storagePath'] = null;
    }
    if (this.thumbnailPath != null) {
      json[r'thumbnailPath'] = this.thumbnailPath;
    } else {
      json[r'thumbnailPath'] = null;
    }
    if (this.mediaType != null) {
      json[r'mediaType'] = this.mediaType;
    } else {
      json[r'mediaType'] = null;
    }
    if (this.sizeBytes != null) {
      json[r'sizeBytes'] = this.sizeBytes;
    } else {
      json[r'sizeBytes'] = null;
    }
    if (this.creationTime != null) {
      json[r'creationTime'] = this.creationTime!.toUtc().toIso8601String();
    } else {
      json[r'creationTime'] = null;
    }
    if (this.uploadTime != null) {
      json[r'uploadTime'] = this.uploadTime!.toUtc().toIso8601String();
    } else {
      json[r'uploadTime'] = null;
    }
    if (this.metadata != null) {
      json[r'metadata'] = this.metadata;
    } else {
      json[r'metadata'] = null;
    }
    if (this.isFavorite != null) {
      json[r'isFavorite'] = this.isFavorite;
    } else {
      json[r'isFavorite'] = null;
    }
    return json;
  }

  /// Returns a new [Media] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Media? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return Media(
        id: mapValueOfType<int>(json, r'id'),
        shareToken: mapValueOfType<String>(json, r'shareToken'),
        originalFilename: mapValueOfType<String>(json, r'originalFilename'),
        storagePath: mapValueOfType<String>(json, r'storagePath'),
        thumbnailPath: mapValueOfType<String>(json, r'thumbnailPath'),
        mediaType: mapValueOfType<String>(json, r'mediaType'),
        sizeBytes: mapValueOfType<int>(json, r'sizeBytes'),
        creationTime: mapDateTime(json, r'creationTime', r''),
        uploadTime: mapDateTime(json, r'uploadTime', r''),
        metadata: MediaMetadata.fromJson(json[r'metadata']),
        isFavorite: mapValueOfType<bool>(json, r'isFavorite'),
      );
    }
    return null;
  }

  static List<Media> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Media>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Media.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Media> mapFromJson(dynamic json) {
    final map = <String, Media>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Media.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Media-objects as value to a dart map
  static Map<String, List<Media>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Media>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Media.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

