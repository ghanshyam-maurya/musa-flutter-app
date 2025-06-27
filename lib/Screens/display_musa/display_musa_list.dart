import 'package:musa_app/Cubit/display_musa/display_cubit.dart';
import 'package:musa_app/Cubit/display_musa/display_state.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import '../../../Utility/packages.dart';
import 'display_feed_widgets.dart';

class DisplayMusaList extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> isMainScrolling;
  final DisplayCubit displayCubit;

  const DisplayMusaList({
    super.key,
    required this.scrollController,
    required this.isMainScrolling,
    required this.displayCubit,
  });

  @override
  State<DisplayMusaList> createState() => _SocialMusaListState();
}

class _SocialMusaListState extends State<DisplayMusaList> {
  late DisplayCubit displayCubit;
  late ScrollController _innerScrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    displayCubit = widget.displayCubit;
    widget.displayCubit.myMusaList.clear();
    widget.displayCubit.homePageNumber = 1;
    widget.displayCubit.getMyFeeds(
        page: widget.displayCubit.homePageNumber,
        userId: widget.displayCubit.myUserId.toString());

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
            _innerScrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        !displayCubit.noDataNextPage) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoadingMore = true);
    await displayCubit.getMyFeeds(
        page: displayCubit.homePageNumber + 1,
        userId: widget.displayCubit.myUserId.toString());
    setState(() => _isLoadingMore = false);
  }

  Future<void> onRefresh() async {
    if (widget.isMainScrolling.value) {
      displayCubit.homePageNumber = 1;
      displayCubit.getMyFeeds(
          page: displayCubit.homePageNumber,
          userId: widget.displayCubit.myUserId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.isMainScrolling,
        builder: (context, isMainScrollActive, child) {
          return BlocConsumer<DisplayCubit, DisplayState>(
            bloc: displayCubit,
            buildWhen: (previous, current) {
              // ✅ Rebuild UI only if list data changes
              return current is MyListSuccess || current is MyListLoading;
            },
            listener: (context, state) {
              if (state is EditMusaLoaded) {
                displayCubit.getMyFeeds(
                    page: displayCubit.homePageNumber,
                    userId: widget.displayCubit.myUserId.toString());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'MUSA visibility updated successfully',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColor.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                );
              } else if (state is EditMusaError) {
                // Show error snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Something went wrong',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  state is MyListSuccess
                      ? displayCubit.myMusaList.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: isMainScrollActive
                                  ? null
                                  : _innerScrollController,
                              itemCount: displayCubit.myMusaList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == displayCubit.myMusaList.length) {
                                  if (_isLoadingMore) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(
                                            color: AppColor.primaryColor),
                                      ),
                                    );
                                  } else if (displayCubit.noDataNextPage) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(""),
                                      ),
                                    );
                                  }
                                  return Container();
                                }

                                return Column(
                                  children: [
                                    CommonSubWidgets(
                                      musaData: displayCubit.myMusaList[index],
                                      displayCubit: displayCubit,
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
                  if (state is MyListLoading)
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
