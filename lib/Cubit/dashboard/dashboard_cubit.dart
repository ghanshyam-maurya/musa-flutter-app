import 'package:musa_app/Cubit/dashboard/dashboard_state.dart';
import 'package:musa_app/Utility/packages.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  int index = 0;

  changeIndex(int value) {
    index = value;
    emit(DashboardInitial());
  }
}
