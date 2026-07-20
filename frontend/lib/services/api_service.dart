import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../models/media.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/photos';

  static String getPreviewUrl(String shareToken) {
    return '$baseUrl/preview/$shareToken';
  }

  Future<MediaPage> fetchPhotos(int page, {int size = 20}) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page&size=$size'));
    if (response.statusCode == 200) {
      return MediaPage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<Media> getDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load photo detail');
    }
  }

  Future<void> deletePhoto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete photo');
    }
  }

  Future<List<Media>> uploadFiles(List<PlatformFile> files) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
    
    for (var file in files) {
      if (file.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.name,
          // We can guess mime type here if needed, but backend handles it
        ));
      }
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Media>.from(l.map((model) => Media.fromJson(model)));
    } else {
      throw Exception('Failed to upload files: ${response.body}');
    }
  }
}
