import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:musa_app/Screens/dashboard/home/random_video_play.dart';
import '../../../Cubit/display_mode_cubit/display_mode_cubit.dart';
import '../../../Cubit/display_mode_cubit/display_mode_state.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';

import 'display_view_image_detail.dart';
import 'display_view_video_containers.dart';

class DisplayModeLandscape extends StatefulWidget {
  final MusaData? displayViewItems;

  const DisplayModeLandscape({
    super.key,
    required this.displayViewItems,
  });

  @override
  State<DisplayModeLandscape> createState() => _DisplayModeLandscapeState();
}

class _DisplayModeLandscapeState extends State<DisplayModeLandscape> {
  final DisplayModeCubit displayModeCubit = DisplayModeCubit();

  @override
  void initState() {
    // TODO: implement initState
    print(widget.displayViewItems!.file?[0].toString());
    print("DATA------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        minimum: EdgeInsets.zero,
        left: false,
        right: false,
        top: false,
        bottom: false,
        child: Scaffold(
          extendBody: true,
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Container(
                  alignment: Alignment.center,
                  color: AppColor.black,
                  child: (widget.displayViewItems != null &&
                          widget.displayViewItems!.file != null &&
                          widget.displayViewItems!.file!.isNotEmpty)
                      ? Center(
                          child: CollageStaggeredGridScreen(
                              displayViewImageItems:
                                  widget.displayViewItems!.file,
                              musaDetails: widget.displayViewItems),
                        )
                      : Center(
                          child: Text(
                          "NO DATA FOUND",
                          style: AppTextStyle.appBarTitleStyle
                              .copyWith(color: AppColor.white),
                        ))),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.sp,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ]);
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 30,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StaggeredGridItem {
  final double heightFactor;
  final bool isClickable;

  StaggeredGridItem({
    required this.heightFactor,
    this.isClickable = false,
  });
}

class CollageStaggeredGridScreen extends StatefulWidget {
  final List<FileElement>? displayViewImageItems;
  final musaDetails;

  const CollageStaggeredGridScreen(
      {super.key, required this.displayViewImageItems, this.musaDetails});

  @override
  _CollageStaggeredGridScreenState createState() =>
      _CollageStaggeredGridScreenState();
}

class _CollageStaggeredGridScreenState
    extends State<CollageStaggeredGridScreen> {
  late Timer _timer;
  final DisplayModeCubit displayModeCubit = DisplayModeCubit();

  @override
  void initState() {
    super.initState();

    displayModeCubit.separateItems(widget.displayViewImageItems);

    if (displayModeCubit.imageList.isNotEmpty) {
      displayModeCubit.initializeImages(displayModeCubit.imageList);
    } else {
      displayModeCubit.initializeImages(displayModeCubit.videoList);
    }

    _startInitialAnimation();
  }

  // void _startAnimation() {
  //   _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
  //     if (displayModeCubit.imageList.isNotEmpty) {
  //       displayModeCubit.updateImages(displayModeCubit.imageList);
  //     } else {
  //       displayModeCubit.updateImages(displayModeCubit.videoList);
  //     }
  //   });
  // }

  void _startInitialAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (displayModeCubit.imageList.isNotEmpty) {
        displayModeCubit.updateImages(displayModeCubit.imageList);
      } else {
        displayModeCubit.updateImages(displayModeCubit.videoList);
      }

      _startPeriodicAnimation();
    });
  }

  void _startPeriodicAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (displayModeCubit.imageList.isNotEmpty) {
        displayModeCubit.updateImages(displayModeCubit.imageList);
      } else {
        displayModeCubit.updateImages(displayModeCubit.videoList);
      }
    });
  }

  final List<StaggeredGridItem> gridItems = [
    StaggeredGridItem(
      heightFactor: 0.5,
    ),
    StaggeredGridItem(
      heightFactor: 0.3,
    ), // Index 1

    StaggeredGridItem(heightFactor: 0.4), // top right
    StaggeredGridItem(heightFactor: 0.3), // center
    StaggeredGridItem(heightFactor: 0.5),
    StaggeredGridItem(heightFactor: 0.4), // Index 5
    StaggeredGridItem(heightFactor: 0.3),
  ];

  @override
  void dispose() {
    _timer.cancel();

    displayModeCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => displayModeCubit,
      child: BlocBuilder<DisplayModeCubit, DisplayModeState>(
        builder: (context, state) {
          if (state is DisplayModeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DisplayModeFetched) {
            final images = state.images;

            return Center(
              child: MasonryGridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final image = images[index];
                  if (index == 1 || index == 5) {
                    return displayModeCubit.videoList.isNotEmpty
                        ? (displayModeCubit.videoList.length == 1)
                            ? InkWell(
                                onTap: () {
                                  DisplayViewImageDetail.showDetailDialog(
                                    context,
                                    musaData: widget.musaDetails,
                                    musaImage: displayModeCubit.videoList[0],
                                  );
                                },
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        gridItems[index].heightFactor,
                                    decoration: BoxDecoration(
                                      color: AppColor.grey,
                                      border: Border.all(
                                          width: 5, color: Colors.black),
                                    ),
                                    child: VideoDisplayView(
                                      url: displayModeCubit.videoList[0],
                                    )),
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height *
                                    gridItems[index].heightFactor,
                                decoration: BoxDecoration(
                                  color: AppColor.grey,
                                  border:
                                      Border.all(width: 5, color: Colors.black),
                                ),
                                child: (index == 1)
                                    ? RandomVideoDisplayOne(
                                        videoList: displayModeCubit.videoList,
                                        musaDetails: widget.musaDetails,
                                      )
                                    : RandomVideoDisplayTwo(
                                        videoList: displayModeCubit.videoList,
                                        musaDetails: widget.musaDetails,
                                      ))
                        : InkWell(
                            onTap: () {
                              if (image.isNotEmpty) {
                                DisplayViewImageDetail.showDetailDialog(
                                  context,
                                  musaData: widget.musaDetails,
                                  musaImage: image,
                                );
                              }
                              debugPrint("Tapped Button");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                  gridItems[index].heightFactor,
                              decoration: BoxDecoration(
                                color: AppColor.grey,
                                border:
                                    Border.all(width: 5, color: Colors.black),
                                image: image.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: image.isEmpty
                                  ?

                                  // Center(
                                  //         child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 5,)
                                  //       )

                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: MusaWidgets.shimmerAnimation(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              gridItems[index].heightFactor,
                                          width: double.infinity,
                                          radius: 10.0),
                                    )
                                  : null,
                            ),
                          );
                  }

                  return InkWell(
                      onTap: () {
                        if (image.isNotEmpty) {
                          DisplayViewImageDetail.showDetailDialog(
                            context,
                            musaData: widget.musaDetails,
                            musaImage: image,
                          );
                        }
                      },
                      child: Utilities.isVideoUrl(image)
                          ? Container(
                              height: MediaQuery.of(context).size.height *
                                  gridItems[index].heightFactor,
                              decoration: BoxDecoration(
                                color: AppColor.grey,
                                border:
                                    Border.all(width: 5, color: Colors.black),
                              ),
                              child: MusaWidgets.thumbnailView(image,
                                  imageHeight:
                                      MediaQuery.of(context).size.height *
                                          gridItems[index].heightFactor,
                                  imageWidth: double.infinity,
                                  radius: 0.0),

                              // VideoDisplayView(
                              //   url: image,
                              // )
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height *
                                  gridItems[index].heightFactor,
                              decoration: BoxDecoration(
                                color: AppColor.grey,
                                border:
                                    Border.all(width: 5, color: Colors.black),
                                image: image.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: image.isEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: MusaWidgets.shimmerAnimation(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              gridItems[index].heightFactor,
                                          width: double.infinity,
                                          radius: 10.0),
                                    )
                                  // const Center(
                                  //     child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 5,)
                                  // )
                                  : null,
                            ));
                },
              ),
            );
          } else if (state is DisplayModeError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
    );
  }
}
