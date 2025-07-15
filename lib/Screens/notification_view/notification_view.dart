import 'package:timeago/timeago.dart' as timeago;

import '../../Cubit/dashboard/notification_cubit/notification_cubit.dart';
import '../../Cubit/dashboard/notification_cubit/notification_state.dart';
import '../../Repository/AppResponse/notification_list_model.dart';
import '../../Utility/musa_widgets.dart';
import '../../Utility/packages.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationCubit _notificationCubit = NotificationCubit();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationCubit.getNotificationList();
  }

  Widget loader = Container(
      // height: 100,
      child: Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor)));

  Widget noDataFound = Container(
      //height: 100,
      child: Center(child: Text("No Notification Available")));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<NotificationCubit, NotificationState>(
        bloc: _notificationCubit,
        listener: (BuildContext context, NotificationState state) {
          if (state is DisplayRequestUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AllNotificationDeletedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MusaWidgets.commonAppBar(
                height: 110.0,
                backgroundColor: AppColor.white,
                row: Padding(
                  padding: MusaPadding.appBarPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: Icon(Icons.close,
                                color: AppColor.black, size: 24.sp),
                          ),
                          SizedBox(width: 26.sp),
                          Text(
                            StringConst.notificationText,
                            style: AppTextStyle.appBarTitleStyle,
                          ),
                        ],
                      ),
                      _notificationCubit.notificationList!.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                _notificationCubit.deleteAllNotification();
                              },
                              child: Text(
                                StringConst.clearText,
                                style: AppTextStyle.normalBoldTextStyle
                                    .copyWith(color: AppColor.primaryColor),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(),
                unselectedLabelColor: Colors.grey,
                dividerColor: AppColor.grey,
                padding: EdgeInsets.only(bottom: 10),
                labelPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                // Adds space below the tab label
                onTap: (index) {
                  setState(() {});
                },
                tabs: [
                  _buildTab("General", 0),
                  _buildTab("Contributors", 1),
                ],
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // General notification
                      state is NotificationLoading
                          ? loader
                          : state is NotificationSuccess
                              ? _notificationCubit
                                      .generalNotification.isNotEmpty
                                  ? _buildTabContent(
                                      _notificationCubit.generalNotification,
                                      state,
                                      showActions: false)
                                  : noDataFound
                              : Container(),

                      // Contributor notification
                      state is NotificationLoading
                          ? loader
                          : state is NotificationSuccess
                              ? _notificationCubit
                                      .contributorNotification.isNotEmpty
                                  ? _buildTabContent(
                                      _notificationCubit
                                          .contributorNotification,
                                      state,
                                      showActions: false)
                                  : noDataFound
                              : Container(),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        height: 30.sp,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.green : Colors.transparent,
          borderRadius: BorderRadius.circular(15.sp),
          border: Border.all(
            width: 1,
            color: isSelected ? AppColor.greenDark : Colors.black,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyle.normalBoldTextStyle.copyWith(
            fontSize: 12.sp,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Notifications> list, state,
      {required bool showActions}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: list.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Notifications notificationData = list[index];
        String time =
            timeago.format(DateTime.parse('${notificationData.createdAt}'));
        return Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: MusaPadding.horizontalPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MusaWidgets.userProfileAvatar(
                    imageUrl: notificationData.senderPhoto ?? '', //list[index],
                    radius: 20.sp,
                    borderWidth: 3.sp,
                  ),
                  SizedBox(width: 5.sp),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${notificationData.senderFirstName} ${notificationData.senderLastName}',
                              style: AppTextStyle.appBarTitleStyle
                                  .copyWith(fontSize: 13),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                time,
                                style:
                                    AppTextStyle.normalBoldTextStyle.copyWith(
                                  fontSize: 10,
                                  color: AppColor.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showActions)
                          RichText(
                            text: TextSpan(
                                text: '${notificationData.musaName}',
                                style: AppTextStyle.normalBoldTextStyle
                                    .copyWith(color: AppColor.primaryColor)),
                          ),
                        Text(
                          notificationData.message ?? '',
                          style: AppTextStyle.normalBoldTextStyle
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showActions)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 60.sp, vertical: 8.sp),
                child: (notificationData.isLoading != null &&
                        notificationData.isLoading!)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: AppColor.primaryColor),
                      )
                    : Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton("Accept", Colors.green,
                              onPressed: () {
                            setState(() {
                              notificationData.isLoading = true;
                              _notificationCubit
                                  .displayRequestUpdate(
                                      notificationId: notificationData.id ?? '',
                                      status: 'Accept')
                                  .then((value) {
                                notificationData.isLoading = false;
                              });
                            });
                          }),
                          SizedBox(
                            width: 20.sp,
                          ),
                          SizedBox(
                            height: 25.sp,
                            child: MusaWidgets.borderTextButton(
                              borderColor: AppColor.red,
                              textcolor: AppColor.red,
                              minWidth: 15.sp,
                              minHeight: 20.sp,
                              borderWidth: 1,
                              title: "Reject",
                              fontSize: 10.sp,
                              borderRadius: 5.sp,
                              fontWeight: FontWeight.w400,
                              onPressed: () {
                                setState(() {
                                  notificationData.isLoading = true;
                                  _notificationCubit
                                      .displayRequestUpdate(
                                          notificationId:
                                              notificationData.id ?? '',
                                          status: 'Reject')
                                      .then((value) {
                                    notificationData.isLoading = false;
                                  });
                                });
                              },
                            ),
                          )
                        ],
                      ),
              ),
            Divider(),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(String text, Color color,
      {required Function() onPressed}) {
    return SizedBox(
      height: 25.sp,
      child: MusaWidgets.secondaryTextButton(
        minWidth: 15.sp,
        minHeight: 20.sp,
        title: text,
        fontSize: 10.sp,
        borderRadius: 5.sp,
        fontWeight: FontWeight.w400,
        onPressed: onPressed,
      ),
    );
  }
}
