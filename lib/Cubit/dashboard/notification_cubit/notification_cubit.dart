import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../Repository/AppResponse/notification_list_model.dart';
import '../../../Utility/packages.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  Repository repository = Repository();
  List<Notifications>? notificationList = [];
  List<Notifications> generalNotification = [];
  List<Notifications> displayNotification = [];
  List<Notifications> contributorNotification = [];


  //Function for get notification
  Future<void> getNotificationList() async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        emit(NotificationLoading());
        await repository.notificationList()
            .then((value) {
          value.fold((left) {
            if (left.data != null) {
              notificationList = left.data!.notifications;
              if (notificationList!.isNotEmpty) {
                notificationList?.forEach((notification) {
                             if( notification.subjectType == 'Display'){
                                displayNotification.add(notification);
                             }else if( notification.subjectType == 'Contributor'){
                               contributorNotification.add(notification);
                             }else if( notification.subjectType == 'General'){
                               generalNotification.add(notification);
                             }
                              }
                              );
              }
              emit(NotificationSuccess());
            }
          },
                  (right) => NotificationFailure(right.message??StringConst.somethingWentWrong));
        });
      } else {
        emit(NotificationFailure(StringConst.noInternetConnection));
      }
    });
  }

  //Function for clear all notifications
  Future<void> deleteAllNotification() async {
    emit(NotificationLoading());
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        await repository.deleteAllNotifications()
            .then((value) {
          value.fold((left) {
            notificationList!.clear();
            generalNotification.clear();
            displayNotification.clear();
            contributorNotification.clear();
            emit(AllNotificationDeletedSuccess(left.message??''));
          },
                  (right) => NotificationFailure(right.message??StringConst.somethingWentWrong));
        });
      } else {
        emit(NotificationFailure(StringConst.noInternetConnection));
      }
    });
  }

  //Function for accept or reject display request
  Future<void> displayRequestUpdate({required String notificationId, required String status}) async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        await repository.displayUpdateNotification(notificationId: notificationId, status: status)
            .then((value) {
          value.fold((left) {
            if (left.updatedSubject != null) {
              displayNotification.removeWhere((notification) => notification.id == notificationId);
              emit(DisplayRequestUpdated(left.message??''));
            }
          },
                  (right) => NotificationFailure(right.message??StringConst.somethingWentWrong));
        });
      } else {
        emit(NotificationFailure(StringConst.noInternetConnection));
      }
    });
  }
}