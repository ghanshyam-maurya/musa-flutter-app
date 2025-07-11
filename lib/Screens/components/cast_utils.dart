// import 'package:flutter_cast_video/flutter_cast_video.dart';
// import 'package:flutter/material.dart';

// class CastUtils {
//   static void showCastDialog(BuildContext context, List<dynamic> fileList) {
//     final List<String> imageUrls = [];
//     final List<String> videoUrls = [];
//     final List<String> audioUrls = [];

//     for (final file in fileList) {
//       final url = file['file_link'] as String?;
//       if (url == null) continue;
//       if (_isImage(url)) {
//         imageUrls.add(url);
//       } else if (_isVideo(url)) {
//         videoUrls.add(url);
//       } else if (_isAudio(url)) {
//         audioUrls.add(url);
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: Text('Cast Media'),
//           content: SizedBox(
//             width: 300,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (videoUrls.isNotEmpty)
//                   _CastMediaTile(
//                     label: 'Cast Video',
//                     url: videoUrls.first,
//                   ),
//                 if (imageUrls.isNotEmpty)
//                   _CastMediaTile(
//                     label: 'Cast Image',
//                     url: imageUrls.first,
//                   ),
//                 if (audioUrls.isNotEmpty)
//                   _CastMediaTile(
//                     label: 'Cast Audio',
//                     url: audioUrls.first,
//                   ),
//                 if (videoUrls.isEmpty && imageUrls.isEmpty && audioUrls.isEmpty)
//                   const Text('No media found to cast.'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static bool _isImage(String url) {
//     final imageExtensions = [
//       'jpg',
//       'jpeg',
//       'png',
//       'gif',
//       'bmp',
//       'webp',
//       'tiff'
//     ];
//     final ext = url.split('.').last.toLowerCase();
//     return imageExtensions.contains(ext);
//   }

//   static bool _isVideo(String url) {
//     final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm'];
//     final ext = url.split('.').last.toLowerCase();
//     return videoExtensions.contains(ext);
//   }

//   static bool _isAudio(String url) {
//     final audioExtensions = ['mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a'];
//     final ext = url.split('.').last.toLowerCase();
//     return audioExtensions.contains(ext);
//   }
// }

// class _CastMediaTile extends StatefulWidget {
//   final String label;
//   final String url;
//   const _CastMediaTile({required this.label, required this.url});

//   @override
//   State<_CastMediaTile> createState() => _CastMediaTileState();
// }

// class _CastMediaTileState extends State<_CastMediaTile> {
//   ChromeCastController? _controller;
//   bool _loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ChromeCastButton(
//           size: 32,
//           color: Colors.blue,
//           onButtonCreated: (controller) {
//             _controller = controller;
//           },
//         ),
//         const SizedBox(width: 12),
//         Expanded(child: Text(widget.label)),
//         ElevatedButton(
//           onPressed: _loading || _controller == null
//               ? null
//               : () async {
//                   setState(() => _loading = true);
//                   await _controller!.loadMedia(widget.url);
//                   setState(() => _loading = false);
//                 },
//           child: _loading
//               ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(strokeWidth: 2))
//               : const Text('Cast'),
//         ),
//       ],
//     );
//   }
// }
