import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';

import '../../../../Cubit/Comment/comment_cubit.dart';
import '../../../../Cubit/Comment/comment_state.dart';
import '../../../../Resources/CommonWidgets/comment_view.dart';
import '../../../../Resources/component/vidio_play_detail.dart';
import '../../../../Utility/musa_widgets.dart';
import '../../../../Utility/packages.dart';

class MusaPostDetailWithCommentView extends StatefulWidget {
  final MusaData musaData;
  final String musaId;
  final String isVideo;
  final String url;
  final String fileId;
  String? commentCount;
  final Function? likeUpdateCallBack;

  MusaPostDetailWithCommentView({
    super.key,
    required this.musaData,
    required this.musaId,
    required this.isVideo,
    required this.url,
    required this.fileId,
    required this.commentCount,
    this.likeUpdateCallBack,
  });
  @override
  State<MusaPostDetailWithCommentView> createState() =>
      _MusaPostDetailWithCommentViewState();
}

class _MusaPostDetailWithCommentViewState
    extends State<MusaPostDetailWithCommentView> {
  CommentCubit commentCubit = CommentCubit();
  final Repository repository = Repository();
  @override
  void initState() {
    commentCubit.getCommentApi(musaId: widget.musaId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: AppColor.bgGrey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Spacer(),
                      if ((widget.musaData.amIContributorInThisMusa == true) &&
                          (widget.musaData.file?.length ?? 0) > 1)
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 28,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColor.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.sp),
                                side: BorderSide(
                                  color: AppColor.white,
                                  width: 1.sp,
                                ),
                              ),
                              minimumSize: Size(0, 28), // height: 28
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Alert'),
                                  content: Text(
                                      'Are you sure you want to delete this MUSA file?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('No',
                                          style: TextStyle(
                                              color: AppColor.primaryColor)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Yes',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                if (widget.musaData.id != null &&
                                    widget.musaData.id!.isNotEmpty) {
                                  try {
                                    await commentCubit.removeMusaFile(
                                      fileId: widget.fileId,
                                      musaId: widget.musaData.id!,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('File deleted successfully'),
                                        backgroundColor: AppColor.primaryColor,
                                      ),
                                    );
                                    Navigator.of(context)
                                        .pop(); // Go back after delete
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    print(e.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to delete file'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/delete_icon.svg',
                                    width: 14,
                                    height: 14,
                                  ),
                                  SizedBox(width: 6.sp),
                                  Text(
                                    'Delete',
                                    style:
                                        AppTextStyle.normalTextStyle1.copyWith(
                                      fontSize: 14,
                                      color: Color(0xFFFF4343),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 15.h),
              SizedBox(
                height: 350.sp,
                width: MediaQuery.of(context).size.width,
                child: (widget.isVideo == 'true')
                    ? VideoPlayDetailView(
                        url: widget.url,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.url,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 10),
              // BlocBuilder<CommentCubit, CommentState>(
              //     bloc: commentCubit,
              //     builder: (context, state) {
              //       return Padding(
              //         padding: MusaPadding.horizontalPadding,
              //         child: Text(
              //           "${StringConst.commentsText} (${commentCubit.commentCont.toString()})",
              //           style: AppTextStyle.normalBoldTextStyle,
              //         ),
              //       );
              //     }),
              // Expanded(
              //     child: CommentView(
              //   musaId: widget.musaId,
              //   //keyboardType: true,
              //   commentCountBtn: (valu) {
              //     setState(() {
              //       widget.commentCount = valu.toString();
              //     });
              //   },
              // ))
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFE9E9E9),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.musaData.isLikeByMe == true) {
                                  widget.musaData.isLikeByMe = false;
                                  widget.musaData.likeCount =
                                      (widget.musaData.likeCount ?? 0) - 1;
                                } else if (widget.musaData.isLikeByMe ==
                                    false) {
                                  widget.musaData.isLikeByMe = true;
                                  widget.musaData.likeCount =
                                      (widget.musaData.likeCount ?? 0) + 1;
                                }
                              });
                              widget.likeUpdateCallBack!(
                                  widget.musaData.isLikeByMe,
                                  widget.musaData.likeCount);
                              // Check is Album Id or id only
                              repository.likeMusa(
                                  musaId: widget.musaData.id ?? "");
                            },
                            child: SvgPicture.asset(
                              widget.musaData.isLikeByMe ?? false
                                  ? 'assets/svgs/like-true.svg'
                                  : 'assets/svgs/like-false.svg',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            '${widget.musaData.likeCount.toString()}  Likes',
                            style: AppTextStyle.normalTextStyle1
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              buildCommentViewDetails(context);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/comment.svg',
                                  height: 18,
                                  width: 18,
                                  // colorFilter: const ColorFilter.mode(
                                  //   Colors.black,
                                  //   BlendMode.srcIn,
                                  // ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  widget.musaData.textCommentCount.toString(),
                                  style: AppTextStyle.normalTextStyle1
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          InkWell(
                            onTap: () {
                              buildCommentViewDetails(context);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/record.svg',
                                  height: 18,
                                  width: 18,
                                  // colorFilter: const ColorFilter.mode(
                                  //   Colors.black,
                                  //   BlendMode.srcIn,
                                  // ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  widget.musaData.audioCommentCount.toString(),
                                  style: AppTextStyle.normalTextStyle1
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> buildCommentViewDetails(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: CommentView(
                musaId: widget.musaData.id.toString(),
                commentCountBtn: (int count) {
                  setState(() {
                    widget.musaData.commentCount = count;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
