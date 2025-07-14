// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
import 'package:musa_app/Cubit/dashboard/sub_album_musa_cubit/sub_album_musa_cubit.dart';
import 'package:musa_app/Cubit/dashboard/sub_album_musa_cubit/sub_album_musa_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
// import 'package:musa_app/Resources/app_style.dart';
// import 'package:musa_app/Resources/colors.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'display_feed_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class SubAlbumMusaList extends StatefulWidget {
  final String subAlbumId;
  final String subAlbumName;
  const SubAlbumMusaList({
    super.key,
    required this.subAlbumId,
    required this.subAlbumName,
  });

  @override
  State<SubAlbumMusaList> createState() => _SubAlbumMusaListState();
}

class _SubAlbumMusaListState extends State<SubAlbumMusaList> {
  late SubAlbumMusaCubit subAlbumMusaCubit;

  @override
  void initState() {
    super.initState();
    subAlbumMusaCubit = SubAlbumMusaCubit();
    subAlbumMusaCubit.getSubAlbumMusaList(subAlbumId: widget.subAlbumId);
  }

  @override
  void dispose() {
    subAlbumMusaCubit.close();
    super.dispose();
  }

  Future<void> onRefresh() async {
    subAlbumMusaCubit.getSubAlbumMusaList(subAlbumId: widget.subAlbumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                    widget.subAlbumName,
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
          // AppBar
          // MusaWidgets.commonAppBar(
          //   height: 110.0,
          //   row: Padding(
          //     padding: MusaPadding.appBarPadding,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         InkWell(
          //           onTap: () => context.pop(),
          //           child: Icon(Icons.arrow_back_ios,
          //               color: AppColor.black, size: 22),
          //         ),
          //         Text(
          //           widget.subAlbumName,
          //           style: AppTextStyle.appBarTitleStyle,
          //         ),
          //         Spacer(),
          //       ],
          //     ),
          //   ),
          // ),
          // MUSA List
          Expanded(
            child: BlocConsumer<SubAlbumMusaCubit, SubAlbumMusaState>(
              bloc: subAlbumMusaCubit,
              listener: (context, state) {
                if (state is SubAlbumMusaFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    state is SubAlbumMusaSuccess
                        ? subAlbumMusaCubit.subAlbumMusaList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: onRefresh,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller:
                                      subAlbumMusaCubit.scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount:
                                      subAlbumMusaCubit.subAlbumMusaList.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical:
                                          10), // Reduced horizontal padding to utilize more space
                                  itemBuilder: (context, index) {
                                    return CommonSubWidgets(
                                      isMyMUSA: true,
                                      isContributed: false,
                                      isHomeMUSA: false,
                                      musaData: subAlbumMusaCubit
                                          .subAlbumMusaList[index],
                                      //subAlbumMusaCubit: subAlbumMusaCubit,
                                      commentCount: subAlbumMusaCubit
                                              .subAlbumMusaList[index]
                                              .commentCount ??
                                          0,
                                      textCommentCount: subAlbumMusaCubit
                                              .subAlbumMusaList[index]
                                              .textCommentCount ??
                                          0,
                                      audioCommentCount: subAlbumMusaCubit
                                              .subAlbumMusaList[index]
                                              .audioCommentCount ??
                                          0,
                                      commentBtn: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              initialChildSize: 0.8,
                                              minChildSize: 0.5,
                                              expand: false,
                                              builder:
                                                  (context, scrollController) {
                                                return Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: CommentView(
                                                    musaId: subAlbumMusaCubit
                                                        .subAlbumMusaList[index]
                                                        .id
                                                        .toString(),
                                                    commentCountBtn:
                                                        (int count) {
                                                      setState(() {
                                                        subAlbumMusaCubit
                                                            .subAlbumMusaList[
                                                                index]
                                                            .commentCount = count;
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      deleteBtn: () {
                                        setState(() {
                                          subAlbumMusaCubit.deleteMusa(
                                              subAlbumMusaCubit
                                                  .subAlbumMusaList[index]);
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  "No MUSA's Available",
                                  style: AppTextStyle.normalTextStyle(
                                    color: AppColor.grey,
                                    size: 16,
                                  ),
                                ),
                              )
                        : Container(),
                    if (state is SubAlbumMusaLoading)
                      Center(child: MusaWidgets.loader(context: context)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
