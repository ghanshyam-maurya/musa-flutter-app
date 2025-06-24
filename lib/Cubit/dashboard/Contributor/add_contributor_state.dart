import 'package:equatable/equatable.dart';

sealed class AddContributorState extends Equatable {
  const AddContributorState();

  @override
  List<Object> get props => [];
}

final class AddContributorInitial extends AddContributorState {}

final class AddContributorLoading extends AddContributorState {}

final class AddContributorFetched extends AddContributorState {}

final class AddedContributorsInMusa extends AddContributorState {}

final class AddContributorLoaded extends AddContributorState {}
final class AddContributorNoInternet extends AddContributorState {}

final class AddContributorError extends AddContributorState {
  final String? errorMessage;
  const AddContributorError({required this.errorMessage});
}
