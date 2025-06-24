import '../../../Repository/AppResponse/musa_contributors_list_modal.dart';

class ProfileState {}

class TabChangeState extends ProfileState{}

class ProfileInitial extends ProfileState{}

class ProfileLoading extends ProfileState{}

class ProfileSuccess extends ProfileState{}

class ProfileFailure extends ProfileState{}

class OtherUserProfileLoading extends ProfileState{}

class OtherUserProfileSuccess extends ProfileState{}

class OtherUserProfileFailure extends ProfileState{
  final String errorMessage;
  OtherUserProfileFailure(this.errorMessage);
}

//Profile page feeds
class ProfileMyFeedsInitial extends ProfileState{}

class ProfileMyFeedsListLoading extends ProfileState{}

class ProfileMyFeedsListSuccess extends ProfileState{}

class ProfileMyFeedsListFailure extends ProfileState{
  final String errorMessage;
  ProfileMyFeedsListFailure(this.errorMessage);
}

class ProfileContributedFeedsInitial extends ProfileState{}

class ProfileContributedFeedsListLoading extends ProfileState{}

class ProfileContributedFeedsListSuccess extends ProfileState{}

class ProfileContributedFeedsListFailure extends ProfileState{
  final String errorMessage;
  ProfileContributedFeedsListFailure(this.errorMessage);
}

//Musa contributors list state

final class MusaContributorsListLoading extends  ProfileState {}

final class MusaContributorsListLoaded extends  ProfileState {
  final MusaContributorListModel contributorsList;

  MusaContributorsListLoaded(this.contributorsList);
}

final class MusaContributorsListSuccess extends  ProfileState {}

final class MusaContributorsListError extends ProfileState {
  final String message;
  MusaContributorsListError(this.message);
}

final class MusaContributorsListFailed extends ProfileState {}

final class MusaContributorsListNoInternetState extends ProfileState {}


final class RemoveContributorLoading extends ProfileState {
  final String contributorId;
  RemoveContributorLoading(this.contributorId);
}
final class RemoveContributorSuccess extends ProfileState {
  final String contributorId;
  RemoveContributorSuccess(this.contributorId);
}
final class RemoveContributorFailure extends ProfileState {
  final String contributorId;
  final String errorMessage;
  RemoveContributorFailure(this.contributorId,this.errorMessage);
}

