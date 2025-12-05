import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ShareService {
  final ScreenshotController screenshotController = ScreenshotController();

  /// Share simple text
  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Capture a widget as an image and share it
  Future<void> shareWidget({
    required Widget widget,
    required String subject,
    required String text,
    required BuildContext context,
  }) async {
    try {
      // Capture the widget as an image
      final Uint8List? imageBytes = await screenshotController.captureFromWidget(
        widget,
        context: context,
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0,
      );

      if (imageBytes == null) {
        throw Exception('Failed to capture widget');
      }

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/share_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: text,
        subject: subject,
      );
    } catch (e) {
      debugPrint('Error sharing widget: $e');
      // Fallback to text sharing if image fails
      await shareText('$text\n\n$subject');
    }
  }
}
