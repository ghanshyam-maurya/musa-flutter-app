import 'package:intl/intl.dart';
import 'package:musa_app/Cubit/dashboard/Chat/chat_list_cubit.dart';
import 'package:musa_app/Cubit/dashboard/Chat/chat_list_state.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class ChatMainView extends StatefulWidget {
  final String? flowType;

  const ChatMainView({super.key, this.flowType});

  @override
  State<ChatMainView> createState() => _ChatMainViewState();
}

class _ChatMainViewState extends State<ChatMainView> {
  ChatListCubit cubit = ChatListCubit();

  @override
  void initState() {
    super.initState();
    cubit.init();
  }

  Future<void> _handleRefresh() async {
    print("REFRESH RUNS ");
    await cubit.getChatGroupListData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListCubit, ChatListState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is ChatListError) {}
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                backgroundColor: AppColor.white,
                body: Column(
                  children: [
                    MusaWidgets.commonAppBar(
                      height: 130.sp,
                      row: Padding(
                        padding: MusaPadding.appBarPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (widget.flowType == "Profile")
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          GoRouter.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 25,
                                        ),
                                      ),
                                      Text(
                                        StringConst.chatText,
                                        style: AppTextStyle.appBarTitleStyle,
                                      ),
                                    ],
                                  )
                                : Text(
                                    StringConst.chatText,
                                    style: AppTextStyle.appBarTitleStyle
                                        .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                  ),
                            // Row(
                            //   children: [
                            //     /*  Icon(Icons.search,
                            //       color: MusaColoStyles.black, size: 24.sp),*/
                            //     SizedBox(width: 20.sp),
                            //     InkWell(
                            //       onTap: () {
                            //         context
                            //             .push(RouteTo.notificationView);
                            //       },
                            //       child: Icon(
                            //           Icons.notifications_none_outlined,
                            //           color: AppColor.black,
                            //           size: 24.sp),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Expanded(
                      child: (state is ChatListLoading) ||
                              cubit.chatListResponse.data == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : cubit.chatListResponse.data!.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: _handleRefresh,
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: _buildTabContent(),
                                        ),
                                        SizedBox(height: 100.sp),
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text("No chats available"),
                                ),
                    )
                  ],
                )),
          );
        });
  }

  Widget _buildTabContent() {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: cubit.chatListResponse.data?.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            Object? updateData;
            updateData = await context.push(RouteTo.chatView,
                extra: cubit.chatListResponse.data?[index]);
            if (updateData != null && updateData == true) {
              cubit.init();
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: MusaPadding.horizontalPadding,
                child: Row(
                  children: [
                    MusaWidgets.userProfileAvatar(
                      imageUrl:
                          cubit.chatListResponse.data?[index].userDetail?.photo,
                      radius: 30.sp,
                      borderWidth: 3.sp,
                    ),
                    SizedBox(width: 5.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${cubit.chatListResponse.data![index].userDetail!.firstName!} ${cubit.chatListResponse.data![index].userDetail!.lastName!}',
                              style: AppTextStyle.appBarTitleStyle
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            cubit.chatListResponse.data![index].latestChat!
                                .message
                                .toString(),
                            style: AppTextStyle.normalBoldTextStyle
                                .copyWith(fontSize: 12, color: AppColor.grey),
                            maxLines: 2, // Limits the text to 2 lines
                            overflow: TextOverflow
                                .ellipsis, // Displays "..." if the text overflows
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '${DateFormat.H().format(cubit.getConvertdTime(cubit.chatListResponse.data![index].latestChat!.createdAt!))} hour ago',
                      // ,
                      style: AppTextStyle.normalBoldTextStyle.copyWith(
                        fontSize: 10,
                        color: AppColor.hintTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
