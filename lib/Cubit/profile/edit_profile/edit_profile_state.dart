import 'package:equatable/equatable.dart';
import '../../../Repository/AppResponse/Responses/user_detail_modle.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileStateFetched extends EditProfileState {}

final class EditProfileStateNoInternet extends EditProfileState {}

class UserDetailsLoaded extends EditProfileState {
  final UserDetail userDetail;

  const UserDetailsLoaded(this.userDetail);
}

class editProfileSuccess extends EditProfileState {
  final String message;
  const editProfileSuccess(this.message);
}

class ProfilePicUpdateSuccess extends EditProfileState {
  final String message;
  const ProfilePicUpdateSuccess(this.message);
}

class EditProfileError extends EditProfileState {
  final String message;
  const EditProfileError(this.message);
}

class SpeechToTextLoading extends EditProfileState {}

class SpeechToTextSuccess extends EditProfileState {}

class SpeechToTextFailure extends EditProfileState {
  final String errorMessage;
  const SpeechToTextFailure(this.errorMessage);
}
