import '../../Repository/AppResponse/social_musa_list_response.dart';
import '../../Utility/packages.dart';
import 'display_mode_state.dart';

class DisplayModeCubit extends Cubit<DisplayModeState> {
  DisplayModeCubit() : super(DisplayModeInitial());

  List<String> visibleImages = [];
  int currentIndex = 0;
  List<String> imageList = [];
  List<String> videoList = [];
  int videoIndex = 0;
  void initializeImages(List items) {
    try {
      emit(DisplayModeLoading());
      visibleImages = List.generate(7, (index) {
        if (index < items.length) {
          return items[index] ?? '';
        } else {
          return '';
        }
      });
      emit(DisplayModeFetched(visibleImages));
    } catch (e) {
      emit(DisplayModeError('Failed to load images.'));
    }
  }

  void separateItems(List<FileElement>? items) {
    for (var item in items!) {
      String imageLink = item.fileLink.toString();
      print(imageLink.toString());
      print("IMAGE TO SHOW ");
      if (Utilities.isVideoUrl(imageLink)) {
        videoList.add(imageLink);
        videoIndex = videoList.length;
      } else if (imageLink.endsWith('.jpg') ||
          imageLink.endsWith('.jpeg') ||
          imageLink.endsWith('.png') ||
          imageLink.endsWith('.heic') ||
          imageLink.endsWith('.svg') ||
          imageLink.endsWith('.webp') ||
          imageLink.endsWith('.gif') ||
          imageLink.endsWith('.bmp')) {
        imageList.add(imageLink);
      }
    }
  }

  // void separateItems(List<dynamic> items) {
  //
  //
  //
  //   final List<String> imageExtensions = [
  //     '.jpg',
  //     '.jpeg',
  //     '.png',
  //     '.bmp',
  //     '.gif',
  //     '.heic',
  //     '.tiff',
  //     '.webp',
  //     '.svg',
  //   ];
  //
  //   final List<String> videoExtensions = [
  //     '.mp4',
  //     '.mov',
  //     '.avi',
  //     '.wmv',
  //     '.flv',
  //     '.mkv',
  //     '.webm',
  //     '.3gp',
  //     '.m4v',
  //   ];
  //
  //   for (var item in items) {
  //     String imageLink = item.fileLink.toString().toLowerCase();
  //     print(imageLink);
  //     print("IMAGE TO SHOW");
  //
  //     if (videoExtensions.any((ext) => imageLink.endsWith(ext))) {
  //       videoList.add(imageLink);
  //       videoIndex = videoList.length;
  //     } else if (imageExtensions.any((ext) => imageLink.endsWith(ext))) {
  //       imageList.add(imageLink);
  //     }
  //   }
  // }

  void updateImages(List items) {
    if (items.isEmpty) return;

    currentIndex = (currentIndex + 1) % items.length;

    visibleImages = List.generate(7, (index) {
      int actualIndex = (currentIndex + index) % items.length;
      return actualIndex < items.length ? items[actualIndex] ?? '' : '';
    });

    emit(DisplayModeFetched(visibleImages));
  }
}
