class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {}

class SignUpShowPassword extends SignupState {}

class SignUpFailureState extends SignupState {
  final String? errorMessage;
  SignUpFailureState({required this.errorMessage});
}

class SpeechToTextSuccess extends SignupState {}

class SpeechToTextFailure extends SignupState {
  final String errorMessage;
  SpeechToTextFailure(this.errorMessage);
}

class SignUpCheckBox extends SignupState {}
