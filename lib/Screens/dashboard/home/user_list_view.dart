import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musa_app/Resources/colors.dart';

import '../../../Repository/AppResponse/musa_contributors_list_modal.dart';
import '../../../Resources/app_style.dart';
import '../../../Resources/string_const.dart';
import '../../../Utility/musa_widgets.dart';

class UserListView extends StatefulWidget {
  final List<ContributorsData>? usersList;
  final Function(String)? removeCallback;
  final String? isAdd;
  final String? isRemove;
  final String? title;
  final String? subTitle;
  final String? isDisplayRequest;
  final String musaId;

  const UserListView({
    super.key,
    required this.usersList,
    this.removeCallback,
    this.isAdd,
    this.isRemove,
    this.title,
    this.subTitle,
    this.isDisplayRequest,
    required this.musaId,
  });

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<ContributorsData>? _displayedUsers;
  @override
  void initState() {
    super.initState();
    _displayedUsers = widget.usersList;
  }

  @override
  void didUpdateWidget(covariant UserListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the `usersList` has changed
    if (oldWidget.usersList != widget.usersList) {
      setState(() {
        _displayedUsers = widget.usersList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MusaPadding.horizontalPadding,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _displayedUsers!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          var item = _displayedUsers![index];
          return SizedBox(
            height: 68.sp,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      MusaWidgets.userProfileAvatar(
                        imageUrl: item.userDetail?[0].photo,
                        radius: 18.sp,
                        borderWidth: 3.sp,
                      ),
                      SizedBox(width: 5.sp),
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${item.userDetail?[0].firstName} ${item.userDetail?[0].lastName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppTextStyle.normalBoldTextStyle,
                        ),
                      ),
                      SizedBox(width: 5.sp),
                      const Spacer(),
                      // SizedBox(
                      //   height: 25.sp,
                      //   child: MusaWidgets.secondaryTextButton(
                      //     minWidth: 15.sp,
                      //     minHeight: 20.sp,
                      //     title: StringConst.removeText,
                      //     fontSize: 12.sp,
                      //     borderRadius: 5.sp,
                      //     fontWeight: FontWeight.w400,
                      //     onPressed: () {
                      //       if (item.contributorId != null &&
                      //           item.contributorId!.isNotEmpty) {
                      //         // AddContributorCubit().removeContributor(musaTd: widget.musaId, contributorId: item.contributorId??'');
                      //         widget.removeCallback?.call(item
                      //             .contributorId!); // Notify parent on removal
                      //       }
                      //     },
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          if (item.contributorId != null &&
                              item.contributorId!.isNotEmpty) {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Remove Contributor'),
                                  content: Text(
                                      'Are you sure you want to remove this contributor?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel',
                                          style:
                                              TextStyle(color: AppColor.grey)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Yes',
                                          style: TextStyle(
                                              color: AppColor.primaryColor)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                        Navigator.of(context)
                                            .pop(); // Close bottom sheet

                                        // Call the remove callback
                                        widget.removeCallback
                                            ?.call(item.contributorId!);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xFFFFF6F6),
                            border: Border.all(
                                color: Color.fromARGB(144, 221, 162,
                                    162)), // Green color for select
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Text(
                                "Remove",
                                style: TextStyle(
                                  color: Color(0xFFFF4343),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  const Divider(
                    color: AppColor.greyChatBG,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
