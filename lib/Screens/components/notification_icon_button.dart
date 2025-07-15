import '../../Utility/packages.dart';

class NotificationIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const NotificationIconButton({
    Key? key,
    this.onPressed,
    this.iconSize = 24,
    this.padding,
  }) : super(key: key);

  @override
  State<NotificationIconButton> createState() => _NotificationIconButtonState();
}

class _NotificationIconButtonState extends State<NotificationIconButton> {
  bool hasNotification = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    Repository repository = Repository();
    await repository.notificationList().then((value) {
      value.fold((left) {
        if (left.data != null) {
          final notifications = left.data!.notifications;
          if (notifications != null && notifications.isNotEmpty) {
            setState(() {
              hasNotification = true;
              loading = false;
            });
            return;
          }
        }
        setState(() {
          hasNotification = false;
          loading = false;
        });
      }, (right) {
        setState(() {
          hasNotification = false;
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return IconButton(
        padding: widget.padding ?? EdgeInsets.all(8),
        iconSize: widget.iconSize,
        icon: SvgPicture.asset(
          Assets.notification,
          width: widget.iconSize,
          height: widget.iconSize,
        ),
        onPressed: widget.onPressed,
      );
      ;
    }
    return IconButton(
      padding: widget.padding ?? EdgeInsets.all(8),
      iconSize: widget.iconSize,
      icon: SvgPicture.asset(
        hasNotification ? Assets.activeNotification : Assets.notification,
        width: widget.iconSize,
        height: widget.iconSize,
      ),
      onPressed: widget.onPressed,
    );
  }
}
