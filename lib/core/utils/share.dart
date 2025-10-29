import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// Shares a single image (from URL) along with text.
  static Future<void> shareContentWithImage({
    required String message,
    required String imageUrl,
  }) async {
    try {
      final file = await _downloadImage(imageUrl);
      if (file == null) throw Exception('Failed to download image');
      final params = ShareParams(
        text: message,
        files: [XFile(file.path)],
      );
      await SharePlus.instance.share(params);
    } catch (e) {
      print('Error sharing content: $e');
    }
  }

  /// Shares multiple images (from URLs) along with text.
  static Future<void> shareContentWithMultipleImages({
    required String message,
    required List<String> imageUrls,
  }) async {
    try {
      final files = <XFile>[];
      for (final url in imageUrls) {
        final file = await _downloadImage(url);
        if (file != null) files.add(XFile(file.path));
      }

      if (files.isEmpty) throw Exception('No valid images to share');

      await Share.shareXFiles(
        files,
        text: message,
      );
    } catch (e) {
      print('Error sharing multiple images: $e');
    }
  }

  /// Helper to download an image and save temporarily
  static Future<File?> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print('Image download failed: $e');
    }
    return null;
  }
}
