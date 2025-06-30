import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Convert image file to base64 string with compression
  static Future<String?> imageToBase64(File imageFile, {int maxWidth = 800, int quality = 85}) async {
    try {
      // Read the image file
      Uint8List imageBytes = await imageFile.readAsBytes();
      
      // Check file size (if > 5MB, compress more aggressively)
      bool needsCompression = imageBytes.length > 5 * 1024 * 1024; // 5MB
      
      if (needsCompression) {
        maxWidth = 600;
        quality = 70;
      }
      
      // Decode the image
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }
      
      // Resize image if it's too large
      img.Image resizedImage = originalImage;
      if (originalImage.width > maxWidth) {
        int newHeight = (originalImage.height * maxWidth / originalImage.width).round();
        resizedImage = img.copyResize(originalImage, width: maxWidth, height: newHeight);
      }
      
      // Compress the image
      Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: quality)
      );
      
      // Convert to base64
      String base64String = base64Encode(compressedBytes);
      
      // Create data URL format
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      print('Error converting image to base64: $e');
      return null;
    }
  }

  /// Get MIME type based on file extension
  static String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default to JPEG
    }
  }

  /// Extract base64 data from data URL
  static String? extractBase64FromDataUrl(String dataUrl) {
    try {
      if (dataUrl.startsWith('data:')) {
        final parts = dataUrl.split(',');
        if (parts.length == 2) {
          return parts[1];
        }
      }
      return dataUrl; // Return as is if not a data URL
    } catch (e) {
      return null;
    }
  }
}