import 'package:equatable/equatable.dart';

sealed class CreateMusaState extends Equatable {
  const CreateMusaState();

  @override
  List<Object> get props => [];
}

final class CreateMusaInitial extends CreateMusaState {}

final class CreateMusaLoading extends CreateMusaState {}

final class CreateMusaAlbumLoading extends CreateMusaState {}

final class CreateMusaAlbumLoaded extends CreateMusaState {}

final class CreateMusaSubAlbumLoading extends CreateMusaState {}

final class CreateMusaSubAlbumLoaded extends CreateMusaState {}

final class CreateMusaLoaded extends CreateMusaState {}

final class CreateMusaDataFetched extends CreateMusaState {}

final class CreateMusaNoInternet extends CreateMusaState {}

final class CreateMusaUpdated extends CreateMusaState {}

final class CreateMusaFileUpdated extends CreateMusaState {}

final class CreateMusaFileRemove extends CreateMusaState {}

class CreateMusaProgress extends CreateMusaState {
  final double progress;
  const CreateMusaProgress({this.progress = 0.0});
}

class CreateMusaProgressData extends CreateMusaState {}

class CreateMusaMediaLibrary extends CreateMusaState {}

class CreateMusaMediaLoading extends CreateMusaState {}

final class CreateMusaError extends CreateMusaState {
  final String? errorMessage;
  const CreateMusaError({required this.errorMessage});
}
