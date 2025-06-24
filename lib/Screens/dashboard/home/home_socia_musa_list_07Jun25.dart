import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Utility/packages.dart';
import 'display_feed_widgets.dart';

class HomeSocialMusaList extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> isMainScrolling;
  final HomeCubit homeCubit;

  const HomeSocialMusaList({
    super.key,
    required this.scrollController,
    required this.isMainScrolling,
    required this.homeCubit,
  });

  @override
  State<HomeSocialMusaList> createState() => _HomeSocialMusaListState();
}

class _HomeSocialMusaListState extends State<HomeSocialMusaList> {
  late HomeCubit homeCubit;
  late ScrollController _innerScrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    homeCubit = widget.homeCubit;
    widget.homeCubit.socialMusaList.clear();
    widget.homeCubit.homePageNumber = 1;
    widget.homeCubit.getSocialFeeds(page: widget.homeCubit.homePageNumber);

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
        !homeCubit.noDataNextPage) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoadingMore = true);
    await homeCubit.getSocialFeeds(page: homeCubit.homePageNumber);
    setState(() => _isLoadingMore = false);
  }

  Future<void> onRefresh() async {
    if (widget.isMainScrolling.value) {
      homeCubit.homePageNumber = 1;
      homeCubit.getMyFeeds(userId: homeCubit.myUserId.toString(), page: 1);
      homeCubit.getSocialFeeds(page: homeCubit.homePageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.isMainScrolling,
        builder: (context, isMainScrollActive, child) {
          return BlocConsumer<HomeCubit, HomeSocialState>(
            bloc: homeCubit,
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
                      ? homeCubit.socialMusaList.isNotEmpty
                          // ? ListView.builder(
                          //     padding: EdgeInsets.symmetric(horizontal: 10),
                          //     //physics: widget.isMainScrolling.value?NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(), // Prevent bounce effect
                          //     controller: isMainScrollActive
                          //         ? null
                          //         : _innerScrollController,
                          //     itemCount: homeCubit.socialMusaList.length + 1,
                          //     itemBuilder: (context, index) {
                          //       if (index == homeCubit.socialMusaList.length) {
                          //         if (_isLoadingMore) {
                          //           return Center(
                          //             child: Padding(
                          //               padding: EdgeInsets.all(10),
                          //               child: CircularProgressIndicator(
                          //                   color: AppColor.primaryColor),
                          //             ),
                          //           );
                          //         } else if (homeCubit.noDataNextPage) {
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
                          //         musaData: homeCubit.socialMusaList[index],
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
                          //                 initialChildSize: 0.8,
                          //                 minChildSize: 0.5,
                          //                 expand: false,
                          //                 builder: (context, scrollController) {
                          //                   return Container(
                          //                     padding: EdgeInsets.all(16),
                          //                     child: CommentView(
                          //                       musaId: homeCubit
                          //                           .socialMusaList[index].id
                          //                           .toString(),
                          //                       commentCountBtn: (int count) {
                          //                         setState(() {
                          //                           homeCubit
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
                          //         commentCount: homeCubit
                          //                 .socialMusaList[index].commentCount
                          //                 ?.toInt() ??
                          //             0,
                          //       );
                          //     },
                          //   )
                          ? ListView.separated(
                              padding: EdgeInsets
                                  .zero, // No extra padding around the list
                              controller: isMainScrollActive
                                  ? null
                                  : _innerScrollController,
                              itemCount: homeCubit.socialMusaList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == homeCubit.socialMusaList.length) {
                                  if (_isLoadingMore) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                            color: AppColor.primaryColor),
                                      ),
                                    );
                                  } else if (homeCubit.noDataNextPage) {
                                    return Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text("No more data")));
                                  }
                                  return Container();
                                }

                                return CommonSubWidgets(
                                  isMyMUSA: false,
                                  isContributed: false,
                                  isHomeMUSA: true,
                                  musaData: homeCubit.socialMusaList[index],
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
                                          builder: (context, scrollController) {
                                            return Container(
                                              padding: EdgeInsets.all(16),
                                              child: CommentView(
                                                musaId: homeCubit
                                                    .socialMusaList[index].id
                                                    .toString(),
                                                commentCountBtn: (int count) {
                                                  setState(() {
                                                    homeCubit
                                                        .socialMusaList[index]
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
                                  deleteBtn: () {},
                                  commentCount: homeCubit
                                          .socialMusaList[index].commentCount
                                          ?.toInt() ??
                                      0,
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors
                                    .grey[300], // or any light color you prefer
                              ),
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
