import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoggedInLoadingState extends LoginState {}

class LoginAuthorizedState extends LoginState {}

class LoginPlateFormState extends LoginState {}

class UserLoginIncomplete extends LoginState {}

class LoginSuccessState extends LoginState {}

class UserInfoUpdate extends LoginState {}

class LoginFailureState extends LoginState {
  final String? errorMessage;
  const LoginFailureState({required this.errorMessage});
}

class SpeechToTextLoading extends LoginState {}

class SpeechToTextSuccess extends LoginState {}

class SpeechToTextFailure extends LoginState {
  final String errorMessage;
  const SpeechToTextFailure(this.errorMessage);
}

class PasswordObsecure extends LoginState {}
