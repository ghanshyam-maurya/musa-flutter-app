import 'package:musa_app/Utility/packages.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;

  const CommonScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(), // Your common bottom nav
    );
  }
}
