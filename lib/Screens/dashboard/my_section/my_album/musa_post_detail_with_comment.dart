import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Cubit/Comment/comment_cubit.dart';
import '../../../../Cubit/Comment/comment_state.dart';
import '../../../../Resources/CommonWidgets/comment_view.dart';
import '../../../../Resources/component/vidio_play_detail.dart';
import '../../../../Utility/musa_widgets.dart';
import '../../../../Utility/packages.dart';

class MusaPostDetailWithCommentView extends StatefulWidget {
  final String musaId;
  final String isVideo;
  final String url;
  String? commentCount;

  MusaPostDetailWithCommentView(
      {super.key,
      required this.musaId,
      required this.isVideo,
      required this.url,
      required this.commentCount});
  @override
  State<MusaPostDetailWithCommentView> createState() =>
      _MusaPostDetailWithCommentViewState();
}

class _MusaPostDetailWithCommentViewState
    extends State<MusaPostDetailWithCommentView> {
  CommentCubit commentCubit = CommentCubit();

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
            mainAxisAlignment: MainAxisAlignment.start,
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
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      // Text(
                      //   musaData.title ?? '',
                      //   style: AppTextStyle.normalTextStyleNew(
                      //     size: 17,
                      //     color: AppColor.black,
                      //     fontweight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              // MusaWidgets.commonAppBar(
              //   height: 110.0,
              //   row: Padding(
              //     padding: MusaPadding.appBarPadding,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             GoRouter.of(context).pop();
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Icon(Icons.arrow_back_ios,
              //                 color: AppColor.black, size: 22),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 350.sp,
                width: MediaQuery.of(context).size.width,
                child: (widget.isVideo == 'true')
                    ? VideoPlayDetailView(
                        url: widget.url,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.url,
                        fit: BoxFit.contain,
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
              BlocBuilder<CommentCubit, CommentState>(
                  bloc: commentCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: MusaPadding.horizontalPadding,
                      child: Text(
                        "${StringConst.commentsText} (${commentCubit.commentCont.toString()})",
                        style: AppTextStyle.normalBoldTextStyle,
                      ),
                    );
                  }),
              Expanded(
                  child: CommentView(
                musaId: widget.musaId,
                //keyboardType: true,
                commentCountBtn: (valu) {
                  setState(() {
                    widget.commentCount = valu.toString();
                  });
                },
              ))
            ],
          ),
        ],
      ),
    );
  }
}
