import 'package:flutter/material.dart';
import 'package:musa_app/Resources/CommonWidgets/comment_view.dart';
import 'package:musa_app/Screens/dashboard/home/display_feed_widgets.dart';
import '../../../Cubit/dashboard/home_dashboard_cubit/home_cubit.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';

class SocialSearchDelegate extends SearchDelegate {
  final HomeCubit homeCubit;

  SocialSearchDelegate(this.homeCubit);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = homeCubit.socialMusaList
        .where((musa) => musa.userDetail!.any((test) =>
            test.firstName?.toLowerCase().contains(query.toLowerCase()) ??
            false))
        .toList();

    return _buildSearchList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = homeCubit.socialMusaList
        .where((musa) => musa.userDetail!.any((test) =>
            test.firstName?.toLowerCase().contains(query.toLowerCase()) ??
            false))
        .toList();

    return _buildSearchList(suggestions);
  }

  Widget _buildSearchList(List<MusaData> list) {
    return list.isEmpty
        ? Center(child: Text("No results found"))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return CommonSubWidgets(
                isMyMUSA: false,
                isContributed: false,
                isHomeMUSA: true,
                musaData: homeCubit.socialMusaList[index],
                commentCount: homeCubit.socialMusaList[index].commentCount ?? 0,
                commentBtn: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                              musaId:
                                  homeCubit.socialMusaList[index].id.toString(),
                              commentCountBtn: (int count) {
                                homeCubit.socialMusaList[index].commentCount =
                                    count;
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
          );
  }
}
