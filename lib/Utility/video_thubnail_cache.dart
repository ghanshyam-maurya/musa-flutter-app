import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
//import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class VideoThumbnailCache {
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Generate or Fetch Cached Thumbnail
  static Future<File?> getVideoThumbnail(String videoUrl, {int? height}) async {
    try {
      // final tempDir = await getTemporaryDirectory();
      // final fileName = p.basenameWithoutExtension(videoUrl);
      // final thumbPath = p.join(tempDir.path, '$fileName-thumb.jpg');
      // final thumbFile = File(thumbPath);

      // // ✅ Return cached thumbnail if it already exists
      // if (await thumbFile.exists()) return thumbFile;

      // // ✅ Download video file to a temp location first (FFmpegKit needs local path)
      // final videoFile = await _cacheManager.getSingleFile(videoUrl);
      // final localPath = videoFile.path;

      // // ✅ Generate thumbnail using FFmpegKit
      // final command = '-y -i "$localPath" -ss 00:00:01 -vframes 1 "$thumbPath"';
      // final session = await FFmpegKit.execute(command);
      // final returnCode = await session.getReturnCode();

      // if (ReturnCode.isSuccess(returnCode)) {
      //   return File(thumbPath);
      // } else {
      //   print('FFmpeg failed: ${await session.getAllLogsAsString()}');
      //   return null;
      // }
      return null;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }
}
