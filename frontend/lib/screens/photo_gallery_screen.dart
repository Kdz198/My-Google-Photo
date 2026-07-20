import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:openapi/api.dart';
import 'dart:async';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
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
        // Use package:web (modern replacement for dart:html) with XMLHttpRequest + FormData.
        // This is the only reliable multipart upload approach on Flutter Web with Dart 3.7+.
        final formData = web.FormData();
        for (var file in result.files) {
          if (file.bytes != null) {
            final mime = _mimeType(file.name);
            final blobParts = <JSAny>[file.bytes!.buffer.toJS].toJS;
            final blobOptions = web.BlobPropertyBag(type: mime);
            final blob = web.Blob(blobParts, blobOptions);
            // Use callMethod to explicitly call the blob overload of FormData.append:
            // formData.append(name, blob, filename) — the 3-arg blob variant.
            // Calling formData.append() directly from Dart picks the string overload.
            (formData as JSObject).callMethod(
              'append'.toJS,
              'files'.toJS,
              blob,
              file.name.toJS,
            );
          }
        }

        final completer = Completer<int>();
        final xhr = web.XMLHttpRequest();
        xhr.open('POST', 'https://api-photo.kdz.asia/api/photos/upload');
        xhr.addEventListener('load', (web.Event _) {
          completer.complete(xhr.status);
        }.toJS);
        xhr.addEventListener('error', (web.Event _) {
          completer.completeError('Network error');
        }.toJS);
        xhr.send(formData);

        final status = await completer.future;
        if (mounted) {
          if (status == 200) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload successful!')));
            _loadPhotos(refresh: true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $status ${xhr.responseText}')));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
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
