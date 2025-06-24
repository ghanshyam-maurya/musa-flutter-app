import 'package:musa_app/Utility/packages.dart';

class FullScreenImage extends StatelessWidget {
  final AssetEntity asset;

  const FullScreenImage({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: asset.id,
          child: Image.memory(
            MediaPickerBottomSheetState.thumbnails[asset]!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
