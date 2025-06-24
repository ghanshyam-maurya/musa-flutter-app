// abstract class SettingsState {}
//
// final class  SettingsInitial extends  SettingsState {}
//
// class SettingsLoading extends SettingsState {}
//
// class LogoOutSuccess extends SettingsState {
//   final String message;
//   LogoOutSuccess(this.message);
// }
//
// class LogoOutError extends SettingsState {
//   final String message;
//   LogoOutError(this.message);
// }

import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SetupFetched extends SettingsState {}

class LogoOutSuccess extends SettingsState {
  final String message;
  const LogoOutSuccess(this.message);
}

class LogoOutError extends SettingsState {
  final String message;
  const LogoOutError(this.message);
}
