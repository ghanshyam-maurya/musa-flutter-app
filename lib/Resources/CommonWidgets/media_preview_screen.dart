import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';
import 'package:musa_app/Resources/app_style.dart';
import 'package:musa_app/Screens/dashboard/myMusa/MediaPickerSheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewScreen extends StatefulWidget {
  final dynamic cubit;
  final List<AssetEntity> selectedAssets;

  const MediaPreviewScreen(
      {super.key, required this.selectedAssets, required this.cubit});

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  late List<AssetEntity> _previewAssets;

  @override
  void initState() {
    super.initState();
    _previewAssets = List.from(widget.selectedAssets);
    print(_previewAssets);
  }

  /// Opens Media Picker to Add More Items
  Future<void> _addMoreMedia() async {
    final selectedAssets = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => MediaPickerBottomSheet(cubit: widget.cubit),
    );
    if (selectedAssets != null && selectedAssets.isNotEmpty) {
      if (!mounted) return;
      List<AssetEntity> assetEntities =
          await convertIdsToAssetEntities(selectedAssets);

      setState(() {
        for (var asset in assetEntities) {
          if (!_previewAssets
              .any((existingAsset) => existingAsset.id == asset.id)) {
            _previewAssets.add(asset);
          }
        }
      });
    }
  }

  Future<List<AssetEntity>> convertIdsToAssetEntities(List<String> ids) async {
    List<AssetEntity> assetEntities = [];
    for (var id in ids) {
      AssetEntity? assetEntity = await fetchAssetById(id);
      if (assetEntity != null) {
        assetEntities.add(assetEntity);
      }
    }
    return assetEntities;
  }

  Future<AssetEntity?> fetchAssetById(String id) async {
    try {
      return AssetEntity(id: id, typeInt: 1, height: 100, width: 100);
    } catch (e) {
      print("Error fetching asset by ID: $e");
      return null;
    }
  }

  /// Removes Media from the selection
  void _removeMedia(int index) {
    setState(() {
      _previewAssets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            "Preview Media",
            style: AppTextStyle.appBarTitleStyle,
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: _previewAssets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (_, index) {
                  final asset = _previewAssets[index];
                  return FutureBuilder<Uint8List?>(
                    future: asset
                        .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data == null) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (asset.type == AssetType.video) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenMedia(asset: asset),
                                    ),
                                  );
                                } else if (asset.type == AssetType.image) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenMedia(asset: asset),
                                    ),
                                  );
                                }
                              },
                              child: Hero(
                                tag: asset.id,
                                child: CachedNetworkImage(
                                  imageUrl: asset.id,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: GestureDetector(
                                onTap: () => _removeMedia(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (asset.type == AssetType.video) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenMedia(asset: asset),
                                  ),
                                );
                              } else if (asset.type == AssetType.image) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenMedia(asset: asset),
                                  ),
                                );
                              }
                            },
                            child: Hero(
                              tag: asset.id,
                              child: asset.id.startsWith('http')
                                  ? Image.network(
                                      asset.id,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: GestureDetector(
                              onTap: () => _removeMedia(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _addMoreMedia,
                child: const Text("Add More"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _previewAssets);
                },
                child: const Text("Done"),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/// Full-screen preview for images and videos
class FullScreenMedia extends StatelessWidget {
  final AssetEntity asset;

  const FullScreenMedia({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(asset.type == AssetType.video ? "Video" : "Image")),
      body: Center(
        child: FutureBuilder<File?>(
          future: asset.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return const Center(child: Text("Unable to load media"));
            }

            final file = snapshot.data!;
            if (asset.type == AssetType.image) {
              return Image.file(file, fit: BoxFit.contain);
            } else if (asset.type == AssetType.video) {
              return VideoPlayerWidget(file: file);
            }
            return const Center(child: Text("Unsupported format"));
          },
        ),
      ),
    );
  }
}

/// Video player widget to handle video playback
class VideoPlayerWidget extends StatefulWidget {
  final File file;

  const VideoPlayerWidget({super.key, required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
