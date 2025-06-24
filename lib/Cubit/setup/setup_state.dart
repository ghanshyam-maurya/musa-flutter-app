import 'package:equatable/equatable.dart';

sealed class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

final class SetupInitial extends SetupState {}

final class SetupLoading extends SetupState {}

final class SetupFetched extends SetupState {}

final class SetupSuccess extends SetupState {}

final class SetupNoInternet extends SetupState {}

final class SetupError extends SetupState {
  final String? errorMessage;
  const SetupError({required this.errorMessage});
}
