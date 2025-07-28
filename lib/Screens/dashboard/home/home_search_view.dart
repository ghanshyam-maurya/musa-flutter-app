import 'dart:async';

import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Screens/components/notification_icon_button.dart';
import 'package:musa_app/Screens/dashboard/home/display_feed_widgets.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class DashboardSearch extends StatefulWidget {
  final String title;
  const DashboardSearch({super.key, this.title = "Search"});

  @override
  State<DashboardSearch> createState() => _DashboardSearchState();
}

class _DashboardSearchState extends State<DashboardSearch> {
  TextEditingController searchController = TextEditingController();
  HomeCubit cubit = HomeCubit();
  Timer? _debounce;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    // Always load MUSA data
    cubit.getSearchMusaList('', 0);
    cubit.getSocialSearchFeeds(page: 1);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchCleared() {
    // Reset to initial state - always MUSA
    setState(() {
      cubit.getSocialSearchFeeds(page: 1);
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.length >= 1) {
        cubit.getSearchMusaList(query, 0); // Always use index 0 for MUSA
      } else {
        // Clear search and load initial data when query is too short
        setState(() {
          cubit.getSocialSearchFeeds(page: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - 300;
    double dynamicWidth = 80;
    if (widget.title == 'My') {
      dynamicWidth = 35; // Adjust width for 'My' title
    }
    if (widget.title == 'Popular Art') {
      dynamicWidth = 125; // Adjust width for 'Search' title
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white, // Ensure pure white background
        body: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  AppBarMusa3(
                    leading: SizedBox(
                      width: 80,
                      height: 110,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            "Search",
                            style: const TextStyle(
                              color: Color(0xFF222222),
                              fontFamily: 'Manrope',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 42 / 24,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    end: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 10),
                      child: Row(
                        children: [
                          // IconButton(
                          //   icon: SvgPicture.asset(Assets.searchIcon_1),
                          //   onPressed: () {
                          //     // Already in search view
                          //   },
                          // ),
                          IconButton(
                            icon: SvgPicture.asset(Assets.settings),
                            onPressed: () {
                              context.push(RouteTo.settings);
                            },
                          ),
                          NotificationIconButton(
                            iconSize: 24,
                            onPressed: () {
                              context.push(RouteTo.notificationView);
                            },
                          ),
                        ],
                      ),
                    ),
                    title: const SizedBox(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: CommonTextField(
                                controller: searchController,
                                hintText: StringConst.searchMusa,
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                searchController.clear();
                                // _onSearchCleared();
                                // move back to previous screen
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                Assets.clear,
                                height: 45,
                                width: 45,
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
            Expanded(
              child: BlocConsumer<HomeCubit, HomeSocialState>(
                bloc: cubit,
                listener: (context, state) {
                  if (state is SearchMusaSearchLoaded) {
                    setState(() {
                      cubit.socialSearchMusaList = state.myMusaList.data ?? [];
                    });
                  }
                  if (state is SearchMusaSearchSuccess) {
                    setState(() {
                      // Update UI when search is successful
                    });
                  }
                  if (state is HomeMusaSearchError) {
                    MusaPopup.popUpDialouge(
                        context: context,
                        onPressed: () => context.pop(true),
                        buttonText: 'Okay',
                        title: 'Error',
                        description: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      state is HomeMusaSearchLoading
                          ? MusaWidgets.loader(
                              context: context, isForFullHeight: true)
                          : buildSearchScreen(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchScreen() {
    return Container(
      color: Colors.white, // Ensure pure white background for the entire screen
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Removed the tab selection buttons
              SizedBox(height: 10),
              cubit.socialSearchMusaList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cubit.socialSearchMusaList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white, // Ensure pure white background
                          child: Column(
                            children: [
                              CommonSubWidgets(
                                isMyMUSA: false,
                                isContributed: false,
                                isHomeMUSA: true,
                                musaData: cubit.socialSearchMusaList[index],
                                commentCount: cubit.socialSearchMusaList[index]
                                        .commentCount ??
                                    0,
                                commentBtn: () async {
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
                                              musaId: cubit
                                                  .socialSearchMusaList[index]
                                                  .id
                                                  .toString(),
                                              commentCountBtn: (int count) {
                                                setState(() {
                                                  cubit
                                                      .socialSearchMusaList[
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
                                deleteBtn: () {},
                              ),
                              // Add divider after each MUSA item (except the last one)
                              if (index < cubit.socialSearchMusaList.length - 1)
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                            ],
                          ),
                        );
                      })
                  : cubit.isFirstComeMusa
                      ? SizedBox(
                          height: screenHeight,
                          child: Center(child: Text("Search by Musa Here...")),
                        )
                      : SizedBox(
                          height: screenHeight,
                          child: Center(child: Text("No Musa Available")),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
