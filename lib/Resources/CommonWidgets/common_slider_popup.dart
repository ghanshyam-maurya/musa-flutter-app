import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_player.dart';

class CommonSliderPopup extends StatelessWidget {
  final String fileType; // 'image' or 'audio'
  final String filePath;
  final VoidCallback? onRemove;

  const CommonSliderPopup({
    super.key,
    required this.fileType,
    required this.filePath,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: fileType == 'audio'
            ? AudioPlayerPopup(
                filePath: filePath,
                onRemove: onRemove ?? () => Navigator.pop(context),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  filePath,
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }
}
