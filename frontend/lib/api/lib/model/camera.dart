//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Camera {
  /// Returns a new [Camera] instance.
  Camera({
    this.aperture,
    this.iso,
    this.shutterSpeed,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? aperture;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? iso;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? shutterSpeed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Camera &&
    other.aperture == aperture &&
    other.iso == iso &&
    other.shutterSpeed == shutterSpeed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (aperture == null ? 0 : aperture!.hashCode) +
    (iso == null ? 0 : iso!.hashCode) +
    (shutterSpeed == null ? 0 : shutterSpeed!.hashCode);

  @override
  String toString() => 'Camera[aperture=$aperture, iso=$iso, shutterSpeed=$shutterSpeed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.aperture != null) {
      json[r'aperture'] = this.aperture;
    } else {
      json[r'aperture'] = null;
    }
    if (this.iso != null) {
      json[r'iso'] = this.iso;
    } else {
      json[r'iso'] = null;
    }
    if (this.shutterSpeed != null) {
      json[r'shutter_speed'] = this.shutterSpeed;
    } else {
      json[r'shutter_speed'] = null;
    }
    return json;
  }

  /// Returns a new [Camera] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Camera? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return Camera(
        aperture: mapValueOfType<String>(json, r'aperture'),
        iso: mapValueOfType<int>(json, r'iso'),
        shutterSpeed: mapValueOfType<String>(json, r'shutter_speed'),
      );
    }
    return null;
  }

  static List<Camera> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Camera>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Camera.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Camera> mapFromJson(dynamic json) {
    final map = <String, Camera>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Camera.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Camera-objects as value to a dart map
  static Map<String, List<Camera>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Camera>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Camera.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

