import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import 'package:musa_app/Cubit/dashboard/home_dashboard_cubit/home_state.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Screens/dashboard/home/display_feed_widgets.dart';
import 'package:musa_app/Screens/profile/my_profile.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class DashboardSearch extends StatefulWidget {
  const DashboardSearch({super.key});

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
    // Load initial data based on selected tab
    if (cubit.isSelectedIndex == 0) {
      cubit.getSearchMusaList('', cubit.isSelectedIndex);
      cubit.getSocialSearchFeeds(page: 1);
    } else {
      cubit.getInitialUserList();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchCleared() {
    // Reset to initial state based on selected tab
    setState(() {
      if (cubit.isSelectedIndex == 0) {
        // Reset MUSA tab to initial state
        cubit.getSocialSearchFeeds(page: 1);
      } else {
        // Reset User tab to initial state
        cubit.getInitialUserList();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.length >= 2) {
        cubit.getSearchMusaList(query, cubit.isSelectedIndex);
      } else {
        // Clear search and load initial data when query is too short
        setState(() {
          if (cubit.isSelectedIndex == 0) {
            cubit.getSocialSearchFeeds(page: 1);
          } else {
            cubit.getInitialUserList();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - 300;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white, // Ensure pure white background
        body: MusaWidgets.searchAppBar(
          context: context,
          backgroundColor: AppColor.white,
          searchController: searchController,
          onChangedSearch: _onSearchChanged,
          onClearSearch: _onSearchCleared,
          body: BlocConsumer<HomeCubit, HomeSocialState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is SearchMusaSearchLoaded) {
                setState(() {
                  cubit.socialSearchMusaList = state.myMusaList.data ?? [];
                });
              }
              if (state is SearchUserListLoaded) {
                setState(() {
                  // The searchUser list is already updated in the cubit
                  // Force UI update
                });
              }
              if (state is SearchMusaSearchSuccess) {
                setState(() {
                  // Update UI when tab is switched
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
      ),
    );
  }

  buildSearchScreen() {
    return Container(
      color: Colors.white, // Ensure pure white background for the entire screen
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: cubit.searchItem.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            cubit.itemSelection(index);
                            // If there's a search query, re-run the search for the new tab
                            if (searchController.text.length >= 2) {
                              cubit.getSearchMusaList(
                                  searchController.text, index);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: cubit.isSelectedIndex == index
                                    ? AppColor.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 1, color: AppColor.hintTextColor)),
                            child: Text(
                              cubit.searchItem[index],
                              style: TextStyle(
                                  color: cubit.isSelectedIndex == index
                                      ? Colors.white
                                      : AppColor.primaryTextColor),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 15),
              cubit.isSelectedIndex == 0
                  ? cubit.socialSearchMusaList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cubit.socialSearchMusaList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color:
                                  Colors.white, // Ensure pure white background
                              child: Column(
                                children: [
                                  CommonSubWidgets(
                                    isMyMUSA: false,
                                    isContributed: false,
                                    isHomeMUSA: true,
                                    musaData: cubit.socialSearchMusaList[index],
                                    commentCount: cubit
                                            .socialSearchMusaList[index]
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
                                            builder:
                                                (context, scrollController) {
                                              return Container(
                                                padding: EdgeInsets.all(16),
                                                child: CommentView(
                                                  musaId: cubit
                                                      .socialSearchMusaList[
                                                          index]
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
                                  if (index <
                                      cubit.socialSearchMusaList.length - 1)
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
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
                              child:
                                  Center(child: Text("Search by Musa Here...")),
                            )
                          : SizedBox(
                              height: screenHeight,
                              child: Center(child: Text("No Musa Available")),
                            )
                  : cubit.searchUser
                          .where((user) =>
                              (user.firstName != null &&
                                  user.firstName!.trim().isNotEmpty) ||
                              (user.lastName != null &&
                                  user.lastName!.trim().isNotEmpty))
                          .isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cubit.searchUser
                              .where((user) =>
                                  (user.firstName != null &&
                                      user.firstName!.trim().isNotEmpty) ||
                                  (user.lastName != null &&
                                      user.lastName!.trim().isNotEmpty))
                              .length,
                          itemBuilder: (_, index) {
                            // Filter users with valid names
                            final validUsers = cubit.searchUser
                                .where((user) =>
                                    (user.firstName != null &&
                                        user.firstName!.trim().isNotEmpty) ||
                                    (user.lastName != null &&
                                        user.lastName!.trim().isNotEmpty))
                                .toList();

                            final user = validUsers[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyProfile(userId: user.sId),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: CachedNetworkImage(
                                          imageUrl: (user.photo != null &&
                                                  user.photo!.isNotEmpty &&
                                                  user.photo != "null")
                                              ? '${user.photo}'
                                              : 'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Image.network(
                                                  "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png"),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "${user.firstName ?? ''} ${user.lastName ?? ''}"
                                            .trim(),
                                        style: AppTextStyle.normalBoldTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : SizedBox(
                          height: screenHeight,
                          child: Center(child: Text("No User Available")),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
