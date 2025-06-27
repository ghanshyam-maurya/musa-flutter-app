class DisplayState {}

class MyListInitial extends DisplayState {}

class MyListLoading extends DisplayState {}

final class EditMusaInitial extends DisplayState {}

final class EditMusaLoading extends DisplayState {}

final class EditMusaLoaded extends DisplayState {}

final class EditMusaError extends DisplayState {
  final String? errorMessage;
  EditMusaError({required this.errorMessage});
}

class MyListSuccess extends DisplayState {}

class MyListFailure extends DisplayState {
  final String errorMessage;
  MyListFailure(this.errorMessage);
}
