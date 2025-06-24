import 'package:musa_app/Screens/dashboard/home/user_list_view.dart';

import '../../../Cubit/profile/profile_cubit/profile_cubit.dart';
import '../../../Cubit/profile/profile_cubit/profile_state.dart';
import '../../../Repository/AppResponse/musa_contributors_list_modal.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';
import '../../../Utility/packages.dart';

class ContributorsInMusaList extends StatefulWidget {
  final MusaData? musaData;
  final int? contributorCount;
  final Function(int)? contributorRemoveCount;
  const ContributorsInMusaList(
      {super.key,
      this.musaData,
      this.contributorCount,
      this.contributorRemoveCount});

  @override
  State<ContributorsInMusaList> createState() => _ContributorsInMusaListState();
}

class _ContributorsInMusaListState extends State<ContributorsInMusaList> {
  ProfileCubit profileCubit = ProfileCubit();
  String userName = "", userProfileImage = "";
  String title = "", albumName = "", subAlbumName = "";
  int removeCount = 0;
  int contributorCount = 0;

  @override
  void initState() {
    setValues(widget.musaData);
    if (widget.musaData!.id != null && widget.musaData!.id!.isNotEmpty) {
      profileCubit.getContributorListOfMusaApi(
          musaId: widget.musaData!.id ?? '');
    }
    super.initState();
  }

  //Set values from musa of album, sub album, title;
  setValues(musaData) {
    if (musaData != null) {
      if (musaData.userDetail != null && musaData.userDetail!.length > 0) {
        userName =
            '${musaData.userDetail![0].firstName} ${musaData.userDetail![0].lastName}';
        userProfileImage = '${musaData.userDetail![0].photo}';
      }

      if (musaData.albumDetail != null && musaData.albumDetail!.isNotEmpty) {
        albumName = musaData.albumDetail?[0].title ?? '';
      }

      if (musaData.subAlbumDetail != null &&
          musaData.subAlbumDetail!.isNotEmpty) {
        subAlbumName = musaData.subAlbumDetail?[0].title ?? '';
      }
      if (musaData.subAlbumDetail != null &&
          musaData.subAlbumDetail!.isNotEmpty) {
        title = musaData.subAlbumDetail?[0].title ?? '';
      }

      contributorCount = widget.contributorCount ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.sp),
        Padding(
          padding: MusaPadding.horizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        albumName,
                        style: AppTextStyle.appBarTitleStyleBlack
                            .copyWith(color: AppColor.primaryColor),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 2.sp, left: 1.sp, right: 1.sp),
                        child: Icon(Icons.circle,
                            color: AppColor.primaryColor, size: 10.sp),
                      ),
                      Text(
                        subAlbumName,
                        style: AppTextStyle.normalTextStyle1.copyWith(
                            color: AppColor.primaryColor, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    title,
                    style:
                        AppTextStyle.normalBoldTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 25.sp,
                    width: 90.sp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.sp),
                        border: Border.all(width: 1.sp, color: AppColor.grey)),
                    child: Center(
                        child: Text(
                            '$contributorCount ${StringConst.isContributedText}',
                            style: AppTextStyle.normalTextStyle1.copyWith(
                                fontSize: 9.sp, color: AppColor.grey))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        SizedBox(height: 5.sp),
        Expanded(
          child: BlocConsumer<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is MusaContributorsListLoaded) {
                  MusaContributorListModel contributorsList =
                      state.contributorsList;
                  if (contributorsList.data != null &&
                      contributorsList.data!.isNotEmpty) {
                    return UserListView(
                      usersList: contributorsList.data,
                      musaId: widget.musaData!.id ?? "",
                      removeCallback: (id) {
                        setState(() {
                          removeCount++;
                          contributorCount--;
                        });
                        // Update contributorsList locally
                        contributorsList.data!.removeWhere(
                            (contributor) => contributor.contributorId == id);

                        // Notify the cubit of the updated list
                        profileCubit.updateContributorsList(contributorsList);
                        profileCubit.removeContributorApi(
                            musaId: widget.musaData!.id ?? "",
                            contributorId: id);
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      "No Data Found",
                      style: AppTextStyle.normalBoldTextStyle,
                    ),
                  );
                }
                return SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }),
        ),
      ],
    );
  }

  // Widget getContributors(){
  //   Set<String> _loadingContributors = {}; // Track loading state per contributor
  //   return BlocConsumer<ProfileCubit, ProfileState>(
  //       bloc: profileCubit,
  //       listener: (context, state) {},
  //       builder: (context, state) {
  //         if(state is MusaContributorsListLoaded) {
  //           MusaContributorListModel contributorsList = state.contributorsList;
  //           if (contributorsList.data != null && contributorsList.data!.isNotEmpty) {
  //             return UserListView(usersList: contributorsList.data, musaId: widget.musaData!.id??"",
  //               removeCallback: (id) async {
  //                // Update contributorsList locally
  //                 contributorsList.data!.removeWhere((contributor) => contributor.id == id);
  //                 // Update the cubit with the new list
  //                 profileCubit.updateContributorsList(contributorsList);
  //               },
  //               loadingContributors: _loadingContributors,
  //             );
  //           }
  //           return Center(
  //             child: Text(
  //               "No Data Found",
  //               style: AppTextStyle.normalBoldTextStyle,
  //             ),
  //           );
  //         }
  //         return Container(height: 300, child: Center(child: CircularProgressIndicator()),);
  //       });
  // }
}
