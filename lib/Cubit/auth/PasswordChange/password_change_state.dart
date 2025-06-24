class ChangePwState {}

class ChangePwInitial extends ChangePwState {}

class ChangePwLoading extends ChangePwState {}

class ChangePwSuccess extends ChangePwState {
  String? message;
  ChangePwSuccess({required this.message});
}

class ChangePwFailure extends ChangePwState {}

class ShowPassword extends ChangePwState {}

class ChangePwFailureState extends ChangePwState {
  final String? errorMessage;
  ChangePwFailureState({required this.errorMessage});
}
