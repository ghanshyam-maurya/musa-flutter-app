class ForgotPwState {}

class ForgotPwInitial extends ForgotPwState{}

class ForgotPwLoading extends ForgotPwState{}

class ForgotPwSuccess extends ForgotPwState{}

class ForgotPwFailure extends ForgotPwState{}
class ForgotPwFailureState extends ForgotPwState {
  final String? errorMessage;
  ForgotPwFailureState({required this.errorMessage});
}