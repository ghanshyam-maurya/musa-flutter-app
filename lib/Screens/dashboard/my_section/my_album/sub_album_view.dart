import 'package:musa_app/Cubit/dashboard/my_section_cubit/my_section_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Repository/AppResponse/my_section_album_list.dart';
import 'package:musa_app/Screens/dashboard/my_section/my_album/sub_album_musa_list.dart';
import '../../../../Cubit/dashboard/my_section_cubit/my_section_cubit.dart';
import '../../../../Utility/musa_widgets.dart';
import '../../../../Utility/packages.dart';
import 'package:musa_app/Repository/AppResponse/my_section_sub_album_list.dart';

class MyScreenSubAlbumView extends StatefulWidget {
  final String albumId;
  final String albumName;
  final int subAlbumCount;
  final MySectionAlbumData album;
  const MyScreenSubAlbumView(
      {super.key,
      required this.albumId,
      required this.albumName,
      required this.subAlbumCount,
      required this.album});

  @override
  State<MyScreenSubAlbumView> createState() => _MyScreenSubAlbumViewState();
}

class _MyScreenSubAlbumViewState extends State<MyScreenSubAlbumView> {
  MySectionCubit mySectionCubit = MySectionCubit();
  final GlobalKey _moreButtonKey = GlobalKey();
  final TextEditingController _subAlbumNameController = TextEditingController();

  @override
  void initState() {
    mySectionCubit.subAlbumCount = widget.subAlbumCount;
    mySectionCubit.getSubAlbumList(albumId: widget.albumId);
    super.initState();
  }

  @override
  void dispose() {
    _subAlbumNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<MySectionCubit, MySectionState>(
        bloc: mySectionCubit,
        listener: (BuildContext context, MySectionState state) {
          if (state is MyLibraryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MusaWidgets.commonAppBar2(
                height: 110.0,
                row: Container(
                  padding: MusaPadding.appBarPadding,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        child: IconButton(
                          icon: SvgPicture.asset(Assets.backIcon),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Utilities.capitalizeFirstLetter(
                            '${widget.albumName} (${mySectionCubit.subAlbumCount})'),
                        style: AppTextStyle.normalTextStyleNew(
                          size: 17,
                          color: AppColor.black,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // MusaWidgets.commonAppBar(
              //   height: 110.0,
              //   row: Padding(
              //     padding: MusaPadding.appBarPadding,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             context.pop();
              //           },
              //           child: Icon(Icons.arrow_back_ios,
              //               color: AppColor.black, size: 22),
              //         ),
              //         Text(
              //           Utilities.capitalizeFirstLetter(
              //               '${widget.albumName} (${mySectionCubit.subAlbumCount})'),
              //           style: AppTextStyle.appBarTitleStyle,
              //         ),
              //         Spacer(),
              //         // IconButton(
              //         //   key: _moreButtonKey,
              //         //   onPressed: _showDeleteOptions,
              //         //   icon: Icon(Icons.more_vert,
              //         //       color: AppColor.black, size: 22),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 10.h),
              Expanded(
                child: Stack(
                  children: [
                    state is MySubAlbumSuccess
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 2;

                                double itemWidth = (constraints.maxWidth -
                                        8.0 * crossAxisCount) /
                                    crossAxisCount;
                                return Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    // Sub Album List
                                    ...List.generate(
                                      mySectionCubit.subAlbumList!.length,
                                      (index) {
                                        final subAlbumData =
                                            mySectionCubit.subAlbumList![index];

                                        return SizedBox(
                                            width: itemWidth,
                                            child: subAlbumData.file?.isEmpty ??
                                                    true
                                                ? _noMusaCardWidget(
                                                    subAlbumData)
                                                : MusaWidgets
                                                    .commonAlbumFolderGridContainer(
                                                    context,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubAlbumMusaList(
                                                            subAlbumId:
                                                                subAlbumData
                                                                        .id ??
                                                                    '',
                                                            subAlbumName:
                                                                subAlbumData
                                                                        .title ??
                                                                    '',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    images: subAlbumData.file
                                                        as List,
                                                    bgColor: Colors.white,
                                                    albumName: subAlbumData
                                                        .title
                                                        .toString(),
                                                    flowType: "MyMusa",
                                                    folderId: subAlbumData.id
                                                        .toString(),
                                                    showSubAlbum: false,
                                                    subAlbumCount: subAlbumData
                                                        .file!.length
                                                        .toString(),
                                                  )
                                            // Column(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment
                                            //             .start,
                                            //     children: [
                                            //       InkWell(
                                            //         onTap: () {
                                            //           Navigator.push(
                                            //             context,
                                            //             MaterialPageRoute(
                                            //               builder:
                                            //                   (context) =>
                                            //                       SubAlbumMusaList(
                                            //                 subAlbumId:
                                            //                     subAlbumData
                                            //                             .id ??
                                            //                         '',
                                            //                 subAlbumName:
                                            //                     subAlbumData
                                            //                             .title ??
                                            //                         '',
                                            //               ),
                                            //             ),
                                            //           );
                                            //         },
                                            //         child: SizedBox(
                                            //           height: 150,
                                            //           child: Card(
                                            //             elevation: 0.0,
                                            //             color: AppColor
                                            //                 .white,
                                            //             shadowColor:
                                            //                 AppColor.grey,
                                            //             shape:
                                            //                 RoundedRectangleBorder(
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(
                                            //                           15.sp),
                                            //             ),
                                            //             child: ClipRRect(
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(
                                            //                           15),
                                            //               child: GridView
                                            //                   .builder(
                                            //                 // Use GridView.builder instead of GridView.count for better control over item count
                                            //                 padding:
                                            //                     EdgeInsets
                                            //                         .zero, // Remove any padding in GridView
                                            //                 shrinkWrap:
                                            //                     true, // Make sure the grid is wrapped to its content size
                                            //                 physics:
                                            //                     NeverScrollableScrollPhysics(), // Disable scroll in GridView
                                            //                 gridDelegate:
                                            //                     SliverGridDelegateWithFixedCrossAxisCount(
                                            //                   crossAxisCount:
                                            //                       2,
                                            //                   crossAxisSpacing:
                                            //                       8, // Optional: Adjust horizontal spacing
                                            //                   mainAxisSpacing:
                                            //                       8, // Optional: Adjust vertical spacing
                                            //                 ),
                                            //                 itemCount: subAlbumData
                                            //                         .file
                                            //                         ?.length ??
                                            //                     0,
                                            //                 itemBuilder:
                                            //                     (context,
                                            //                         imgIndex) {
                                            //                   return CachedNetworkImage(
                                            //                     imageUrl:
                                            //                         subAlbumData.file?[imgIndex].fileLink ??
                                            //                             '',
                                            //                     fit: BoxFit
                                            //                         .cover,
                                            //                     placeholder:
                                            //                         (context, url) =>
                                            //                             Container(
                                            //                       color: Colors
                                            //                           .grey[200],
                                            //                       height:
                                            //                           10,
                                            //                       width:
                                            //                           10,
                                            //                       child:
                                            //                           Center(
                                            //                         child:
                                            //                             CircularProgressIndicator(
                                            //                           color:
                                            //                               AppColor.primaryColor,
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                     errorWidget: (context,
                                            //                             url,
                                            //                             error) =>
                                            //                         Container(
                                            //                       color: Colors
                                            //                           .grey[200],
                                            //                       child: Icon(
                                            //                           Icons.error),
                                            //                     ),
                                            //                   );
                                            //                 },
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       Padding(
                                            //         padding:
                                            //             EdgeInsets.only(
                                            //                 left: 13.w,
                                            //                 top: 8.h),
                                            //         child: Column(
                                            //           crossAxisAlignment:
                                            //               CrossAxisAlignment
                                            //                   .start,
                                            //           children: [
                                            //             Text(
                                            //               subAlbumData
                                            //                       .title ??
                                            //                   "",
                                            //               style: AppTextStyle
                                            //                   .normalBoldTextStyle
                                            //                   .copyWith(
                                            //                 fontSize: 15,
                                            //                 fontWeight:
                                            //                     FontWeight
                                            //                         .w500,
                                            //               ),
                                            //               maxLines: 1,
                                            //               overflow:
                                            //                   TextOverflow
                                            //                       .ellipsis,
                                            //             ),
                                            //             // Text(
                                            //             //   '${subAlbumData.file?.length ?? 0} Media',
                                            //             //   style: AppTextStyle.normalTextStyle(
                                            //             //     color: AppColor.grey,
                                            //             //     size: 14,
                                            //             //   ),
                                            //             // ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            );
                                      },
                                    ),
                                    // Add Sub Album Container at the end
                                    SizedBox(
                                      width: itemWidth,
                                      child: addAlbumContainer(context),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Container(),
                    state is MySubAlbumLoading
                        ? MusaWidgets.loader(context: context)
                        : Container()
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Card _noMusaCardWidget(MySectionSubAlbumData subAlbumData) {
    return Card(
      elevation: 0.0,
      color: AppColor.white,
      shadowColor: AppColor.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // context.push(
                //   RouteTo.createMusa,
                //   extra: {
                //     'albumName': widget.album,
                //     'subAlbumName': subAlbumData,
                //   },
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMusa(
                      albumName: widget.album,
                      subAlbumName: subAlbumData,
                    ),
                  ),
                );
              },
              child: Container(
                height: 150.sp,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF8FDFA),
                  borderRadius: BorderRadius.circular(15.sp),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFB4C7B9),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create MUSA',
                      style: AppTextStyle.normalBoldTextStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.greenDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubAlbumMusaList(
                      subAlbumId: subAlbumData.id ?? '',
                      subAlbumName: subAlbumData.title ?? '',
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.w, top: 8.h, right: 13.w, bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subAlbumData.title ?? "",
                      style: AppTextStyle.normalBoldTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   'No Media',
                    //   style: AppTextStyle.normalTextStyle(
                    //     color: AppColor.grey,
                    //     size: 14,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addAlbumContainer(BuildContext context) {
    return Container(
      height: 150.sp,
      margin: EdgeInsets.only(top: 10.h),
      width: MediaQuery.of(context).size.width * 0.5 - 30,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: InkWell(
          onTap: _showAddSubAlbumDialog,
          child: DottedBorder(
            color: const Color(0xFFB4C7B9),
            dashPattern: const [5, 5],
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
              color: const Color(0xFFF8FDFA),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/svgs/add-media.svg',
                      width: 21,
                      height: 21,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: const Text(
                      "Add Sub Collection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF00674E),
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 16 / 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddSubAlbumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 30.h,
                  bottom: 30.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Text(
                        'Add MUSA Sub Collection In "${widget.albumName}"',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.mediumTextStyle(
                          color: AppColor.black,
                          size: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      cursorColor: AppColor.greenDark,
                      controller: _subAlbumNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Sub Collection Name',
                        hintStyle: AppTextStyle.normalTextStyle(
                          color: AppColor.greyNew,
                          size: 14,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.greenDark),
                        ),
                        focusColor: AppColor.greenDark,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_subAlbumNameController.text.trim().isNotEmpty) {
                            mySectionCubit.createMusaSubAlbum(
                              title: _subAlbumNameController.text.trim(),
                              albumId: widget.albumId,
                            );
                            Navigator.pop(context);
                            _subAlbumNameController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                        ),
                        child: Text(
                          'Create',
                          style: AppTextStyle.mediumTextStyle(
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 5,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColor.black, size: 25.sp),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteOptions() {
    final RenderBox button =
        _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height + 100,
      ),
      items: [
        PopupMenuItem(
          onTap: () async {},
          child: Row(
            children: [
              Text(
                'Delete',
                style: AppTextStyle.normalTextStyle1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
