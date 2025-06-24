import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Screens/dashboard/home/display_feed_widgets.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Utility/packages.dart';

class HomeSocial extends StatefulWidget {
  final HomeCubit homeCubit;
  const HomeSocial({super.key, required this.homeCubit});

  @override
  State<HomeSocial> createState() => _HomeSocialState();
}

class _HomeSocialState extends State<HomeSocial> {
  final bool _isLoading = false;
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    widget.homeCubit.getSocialFeeds(page: 1);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreItems();
    }
  }

  @override
  void dispose() {
    widget.homeCubit.scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItems() async {
    if (widget.homeCubit.isLoadingMore || widget.homeCubit.noDataNextPage) {
      return;
    }
    widget.homeCubit.loadMoreFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: BlocConsumer<HomeCubit, HomeSocialState>(
        bloc: widget.homeCubit,
        listener: (context, state) {
          if (state is SearchMusaSearchLoaded) {
            setState(() {
              widget.homeCubit.socialMusaList = state.myMusaList.data ?? [];
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              state is SocialListSuccess
                  ? widget.homeCubit.socialMusaList.isNotEmpty
                      ? ListView.builder(
                          controller: _controller,
                          itemCount: widget.homeCubit.socialMusaList.length + 1,
                          itemBuilder: (context, index) {
                            if (index ==
                                widget.homeCubit.socialMusaList.length) {
                              return widget.homeCubit.isLoadingMore
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ))
                                  : widget.homeCubit.noDataNextPage
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text('No more data')),
                                        )
                                      : Container();
                            }
                            return CommonSubWidgets(
                              isMyMUSA: false,
                              isContributed: false,
                              isHomeMUSA: true,
                              musaData: widget.homeCubit.socialMusaList[index],
                              commentCount: widget.homeCubit
                                      .socialMusaList[index].commentCount ??
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
                                      builder: (context, scrollController) {
                                        return Container(
                                          padding: EdgeInsets.all(16),
                                          child: CommentView(
                                            musaId: widget.homeCubit
                                                .socialMusaList[index].id
                                                .toString(),
                                            commentCountBtn: (int count) {
                                              setState(() {
                                                widget
                                                    .homeCubit
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
                            );
                          },
                        )
                      : Center(child: Text("No Musa's Available"))
                  : Center(child: Text("Loading...")),
              if (state is SocialListLoading)
                MusaWidgets.loader(context: context),
            ],
          );
        },
      ),
    );
  }
}
