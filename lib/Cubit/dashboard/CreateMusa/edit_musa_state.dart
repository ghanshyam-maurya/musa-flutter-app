import 'package:equatable/equatable.dart';

sealed class EditMusaState extends Equatable {
  const EditMusaState();

  @override
  List<Object> get props => [];
}

final class EditMusaInitial extends EditMusaState {}

final class EditMusaLoading extends EditMusaState {}

final class EditMusaAlbumLoading extends EditMusaState {}

final class EditMusaAlbumLoaded extends EditMusaState {}

final class EditMusaSubAlbumLoading extends EditMusaState {}

final class EditMusaSubAlbumLoaded extends EditMusaState {}

final class EditMusaLoaded extends EditMusaState {}

final class EditMusaDataFetched extends EditMusaState {}

final class EditMusaNoInternet extends EditMusaState {}

final class EditMusaUpdated extends EditMusaState {}

final class EditMusaFileUpdated extends EditMusaState {}

final class EditMusaFileRemove extends EditMusaState {}

class EditMusaProgress extends EditMusaState {
  final double progress;
  const EditMusaProgress({this.progress = 0.0});
}

class EditMusaProgressData extends EditMusaState {}

class EditMusaMediaLibrary extends EditMusaState {}

class EditMusaMediaLoading extends EditMusaState {}

final class EditMusaError extends EditMusaState {
  final String? errorMessage;
  const EditMusaError({required this.errorMessage});
}

final class EditMusaDescriptionUpdated extends EditMusaState {
  final String description;
  const EditMusaDescriptionUpdated({required this.description});
}
