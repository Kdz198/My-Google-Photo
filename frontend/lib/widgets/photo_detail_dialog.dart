import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/api.dart';

class PhotoDetailDialog extends StatelessWidget {
  final Media media;
  final PhotoControllerApi api;
  final String previewUrl;

  const PhotoDetailDialog({Key? key, required this.media, required this.api, required this.previewUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 800,
        height: 600,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black87,
                child: Image.network(
                  previewUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<Media?>(
                future: api.getDetail(media.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return _buildDetails(context, snapshot.data!);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, Media detailedMedia) {
    String formattedTime = detailedMedia.uploadTime != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(detailedMedia.uploadTime!)
        : 'Unknown';
    String sizeMB = detailedMedia.sizeBytes != null ? (detailedMedia.sizeBytes! / (1024 * 1024)).toStringAsFixed(2) : '0.00';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Info',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Filename', detailedMedia.originalFilename ?? 'Unknown'),
          _buildInfoRow('Size', '$sizeMB MB'),
          _buildInfoRow('Uploaded', formattedTime),
          if (detailedMedia.metadata != null) ...[
            const Divider(height: 32),
            const Text('Metadata', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (detailedMedia.metadata!.width != null)
              _buildInfoRow('Resolution', '${detailedMedia.metadata!.width} x ${detailedMedia.metadata!.height}'),
            if (detailedMedia.metadata!.mimeType != null)
              _buildInfoRow('Type', detailedMedia.metadata!.mimeType!),
            if (detailedMedia.metadata!.device != null)
              _buildInfoRow('Device', '${detailedMedia.metadata!.device?.make ?? ""} ${detailedMedia.metadata!.device?.model ?? ""}'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
