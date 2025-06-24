import 'package:musa_app/Cubit/art/art_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Cubit/art/art_cubit.dart';
import '../../../Utility/packages.dart';
import 'display_feed_widgets.dart';

class ArtMusaList extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> isMainScrolling;
  final ArtCubit artCubit;

  const ArtMusaList({
    super.key,
    required this.scrollController,
    required this.isMainScrolling,
    required this.artCubit,
  });

  @override
  State<ArtMusaList> createState() => _ArtMusaListState();
}

class _ArtMusaListState extends State<ArtMusaList> {
  late ArtCubit artCubit;
  late ScrollController _innerScrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    artCubit = widget.artCubit;
    widget.artCubit.socialMusaList.clear();
    widget.artCubit.homePageNumber = 1;
    widget.artCubit.getSocialFeeds(page: widget.artCubit.homePageNumber);

    _innerScrollController = ScrollController();
    _innerScrollController.addListener(_innerScrollListener);
  }

  @override
  void dispose() {
    _innerScrollController.dispose();
    super.dispose();
  }

  void _innerScrollListener() {
    if (_innerScrollController.position.pixels == 0) {
      widget.isMainScrolling.value = true; // Main scroll resumes
    }

    if (_innerScrollController.position.pixels >=
            _innerScrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        !artCubit.noDataNextPage) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoadingMore = true);
    await artCubit.getSocialFeeds(page: artCubit.homePageNumber);
    setState(() => _isLoadingMore = false);
  }

  Future<void> onRefresh() async {
    if (widget.isMainScrolling.value) {
      artCubit.homePageNumber = 1;
      artCubit.getMyFeeds(userId: artCubit.myUserId.toString(), page: 1);
      artCubit.getSocialFeeds(page: artCubit.homePageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.isMainScrolling,
        builder: (context, isMainScrollActive, child) {
          return BlocConsumer<ArtCubit, ArtSocialState>(
            bloc: artCubit,
            buildWhen: (previous, current) {
              // ✅ Rebuild UI only if list data changes
              return current is SocialListSuccess ||
                  current is SocialListLoading;
            },
            listener: (context, state) {},
            builder: (context, state) {
              return Stack(
                children: [
                  state is SocialListSuccess
                      ? artCubit.socialMusaList.isNotEmpty
                          // ? ListView.separated(
                          //     padding: EdgeInsets
                          //         .zero, // No extra padding around the list
                          //     controller: isMainScrollActive
                          //         ? null
                          //         : _innerScrollController,
                          //     itemCount: artCubit.socialMusaList.length + 1,
                          //     itemBuilder: (context, index) {
                          //       if (index == artCubit.socialMusaList.length) {
                          //         if (_isLoadingMore) {
                          //           return Center(
                          //             child: Padding(
                          //               padding: EdgeInsets.all(10),
                          //               child: CircularProgressIndicator(
                          //                   color: AppColor.primaryColor),
                          //             ),
                          //           );
                          //         } else if (artCubit.noDataNextPage) {
                          //           return Center(
                          //               child: Padding(
                          //                   padding: EdgeInsets.all(8),
                          //                   child: Text("No more data")));
                          //         }
                          //         return Container();
                          //       }

                          //       return CommonSubWidgets(
                          //         isMyMUSA: false,
                          //         isContributed: false,
                          //         isHomeMUSA: true,
                          //         musaData: artCubit.socialMusaList[index],
                          //         commentBtn: () {
                          //           showModalBottomSheet(
                          //             context: context,
                          //             isScrollControlled: true,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.vertical(
                          //                   top: Radius.circular(20)),
                          //             ),
                          //             builder: (context) {
                          //               return DraggableScrollableSheet(
                          //                 initialChildSize: 0.95,
                          //                 minChildSize: 0.7,
                          //                 expand: false,
                          //                 builder: (context, scrollController) {
                          //                   return Container(
                          //                     padding: EdgeInsets.all(16),
                          //                     child: CommentView(
                          //                       musaId: artCubit
                          //                           .socialMusaList[index].id
                          //                           .toString(),
                          //                       commentCountBtn: (int count) {
                          //                         setState(() {
                          //                           artCubit
                          //                               .socialMusaList[index]
                          //                               .commentCount = count;
                          //                         });
                          //                       },
                          //                     ),
                          //                   );
                          //                 },
                          //               );
                          //             },
                          //           );
                          //         },
                          //         deleteBtn: () {},
                          //         commentCount: artCubit
                          //                 .socialMusaList[index].commentCount
                          //                 ?.toInt() ??
                          //             0,
                          //       );
                          //     },
                          //     separatorBuilder: (context, index) => Divider(
                          //       height: 1,
                          //       thickness: 1,
                          //       color: Colors
                          //           .grey[300], // or any light color you prefer
                          //     ),
                          //   )
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: isMainScrollActive
                                  ? null
                                  : _innerScrollController,
                              itemCount: artCubit.socialMusaList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == artCubit.socialMusaList.length) {
                                  if (_isLoadingMore) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                            color: AppColor.primaryColor),
                                      ),
                                    );
                                  } else if (artCubit.noDataNextPage) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("No more data"),
                                      ),
                                    );
                                  }
                                  return Container();
                                }

                                return Column(
                                  children: [
                                    CommonSubWidgets(
                                      isMyMUSA: false,
                                      isContributed: false,
                                      isHomeMUSA: true,
                                      musaData: artCubit.socialMusaList[index],
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
                                              initialChildSize: 0.95,
                                              minChildSize: 0.7,
                                              expand: false,
                                              builder:
                                                  (context, scrollController) {
                                                return Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: CommentView(
                                                    musaId: artCubit
                                                        .socialMusaList[index]
                                                        .id
                                                        .toString(),
                                                    commentCountBtn:
                                                        (int count) {
                                                      setState(() {
                                                        artCubit
                                                                .socialMusaList[
                                                                    index]
                                                                .commentCount =
                                                            count;
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      deleteBtn: () {},
                                      commentCount: artCubit
                                              .socialMusaList[index]
                                              .commentCount
                                              ?.toInt() ??
                                          0,
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                );
                              },
                            )
                          : Center(child: Text("No MUSA's Available"))
                      : Container(),
                  if (state is SocialListLoading)
                    MusaWidgets.loader(context: context),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
