import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:openapi/api.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../widgets/photo_card.dart';
import '../widgets/photo_detail_dialog.dart';


class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final PhotoControllerApi _api = PhotoControllerApi(ApiClient(basePath: 'https://api-photo.kdz.asia'));
  final ScrollController _scrollController = ScrollController();
  
  List<Media> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  bool _isUploading = false;

  String getPreviewUrl(String shareToken) => 'https://api-photo.kdz.asia/api/photos/preview/$shareToken';

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
      _loadPhotos();
    }
  }

  Future<void> _loadPhotos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _photos.clear();
      _hasMore = true;
    }

    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final page = await _api.listFiles(page: _currentPage, size: 20);
      setState(() {
        if (page?.content != null) {
          _photos.addAll(page!.content!);
        }
        _hasMore = !(page?.last ?? true);
        _currentPage++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load photos: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Resolve MIME type from file extension — required so Spring Boot's @RequestPart
  /// sees a Content-Type per part and doesn't reject the upload.
  String _mimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    const map = {
      'jpg': 'image/jpeg', 'jpeg': 'image/jpeg',
      'png': 'image/png', 'gif': 'image/gif',
      'webp': 'image/webp', 'bmp': 'image/bmp',
      'heic': 'image/heic', 'heif': 'image/heif',
      'mp4': 'video/mp4', 'mov': 'video/quicktime',
      'avi': 'video/x-msvideo', 'mkv': 'video/x-matroska',
    };
    return map[ext] ?? 'application/octet-stream';
  }

  Future<void> _uploadPhotos() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      try {
        // Build multipart/form-data body manually — identical to how curl constructs it.
        // This bypasses ALL browser FormData / XHR issues in Flutter Web.
        final boundary = 'dart-boundary-${DateTime.now().millisecondsSinceEpoch}';
        final bodyBytes = <int>[];

        for (var file in result.files) {
          if (file.bytes != null) {
            final mime = _mimeType(file.name);
            // Part header
            bodyBytes.addAll('--$boundary\r\n'.codeUnits);
            bodyBytes.addAll(
              'Content-Disposition: form-data; name="files"; filename="${file.name}"\r\n'
              .codeUnits,
            );
            bodyBytes.addAll('Content-Type: $mime\r\n'.codeUnits);
            bodyBytes.addAll('\r\n'.codeUnits);
            // File bytes
            bodyBytes.addAll(file.bytes!);
            bodyBytes.addAll('\r\n'.codeUnits);
          }
        }
        // Closing boundary
        bodyBytes.addAll('--$boundary--\r\n'.codeUnits);

        final response = await http.post(
          Uri.parse('https://api-photo.kdz.asia/api/photos/upload'),
          headers: {'Content-Type': 'multipart/form-data; boundary=$boundary'},
          body: Uint8List.fromList(bodyBytes),
        );

        if (mounted) {
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload successful!')));
            _loadPhotos(refresh: true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload failed: ${response.statusCode} ${response.body}')));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $e')));
        }
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _deletePhoto(Media media) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete', style: TextStyle(color: Colors.white))
          ),
        ],
      )
    );

    if (confirm == true) {
      try {
        await _api.deleteFile(media.id!);
        setState(() {
          _photos.removeWhere((p) => p.id == media.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  void _showPhotoDetails(Media media) {
    showDialog(
      context: context,
      builder: (context) => PhotoDetailDialog(
        media: media, 
        api: _api,
        previewUrl: getPreviewUrl(media.shareToken!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Google Photo', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (_isUploading) 
            const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadPhotos,
              icon: const Icon(Icons.upload),
              label: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadPhotos(refresh: true),
        child: _photos.isEmpty && !_isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No photos found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _photos.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _photos.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final media = _photos[index];
                    return PhotoCard(
                      media: media,
                      previewUrl: getPreviewUrl(media.shareToken!),
                      onDelete: () => _deletePhoto(media),
                      onViewDetails: () => _showPhotoDetails(media),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
