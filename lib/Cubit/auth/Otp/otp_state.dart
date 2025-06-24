class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}
class OtpResend extends OtpState {
  String? message;
  OtpResend({required this.message});
}

class OtpFailure extends OtpState {}

class OtpFailureState extends OtpState {
  final String? errorMessage;
  OtpFailureState({required this.errorMessage});
}
