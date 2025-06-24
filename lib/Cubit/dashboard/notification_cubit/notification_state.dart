abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {}

class AllNotificationDeletedSuccess extends NotificationState {
  final String message;

  AllNotificationDeletedSuccess(this.message);
}

class NotificationFailure extends NotificationState {
  final String errorMessage;

  NotificationFailure(this.errorMessage);
}

class DisplayRequestUpdated extends NotificationState {
  final String message;

  DisplayRequestUpdated(this.message);
}
