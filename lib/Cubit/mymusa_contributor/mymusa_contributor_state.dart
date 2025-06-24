import 'package:equatable/equatable.dart';
import 'package:musa_app/models/my_musa_contributor_model.dart';

sealed class MyMusaContributorsState extends Equatable {
  const MyMusaContributorsState();

  @override
  List<Object> get props => [];
}

final class MyMusaContributorsInitial extends MyMusaContributorsState {}

final class MyMusaContributorsLoading extends MyMusaContributorsState {}

final class MyMusaContributorsSuccess extends MyMusaContributorsState {
  final List<MusaSection> sections;
  const MyMusaContributorsSuccess(this.sections);
}

final class MyMusaContributorsError extends MyMusaContributorsState {
  final String message;
  const MyMusaContributorsError(this.message);
}

final class ContributorRemovalLoading extends MyMusaContributorsState {}

final class ContributorRemovalSuccess extends MyMusaContributorsState {
  final String message;
  const ContributorRemovalSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ContributorRemovalError extends MyMusaContributorsState {
  final String message;
  const ContributorRemovalError(this.message);

  @override
  List<Object> get props => [message];
}
