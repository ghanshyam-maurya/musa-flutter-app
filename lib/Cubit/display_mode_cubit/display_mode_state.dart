import 'package:equatable/equatable.dart';

sealed class DisplayModeState extends Equatable {
  const DisplayModeState();

  @override
  List<Object> get props => [];
}

class DisplayModeInitial extends DisplayModeState {}

class DisplayModeLoading extends DisplayModeState {}

class DisplayModeFetched extends DisplayModeState {
  final List<String> images;
  const DisplayModeFetched(this.images);

  @override
  List<Object> get props => [images];
}

class DisplayModeError extends DisplayModeState {
  final String message;
  const DisplayModeError(this.message);

  @override
  List<Object> get props => [message];
}
