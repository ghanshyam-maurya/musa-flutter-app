import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';

class HomeSocialState {}

class SocialListInitial extends HomeSocialState {}

class SocialListLoading extends HomeSocialState {}

class NextPageSocialListLoading extends HomeSocialState {}

class SocialListSuccess extends HomeSocialState {}
class SocialListSearchSuccess extends HomeSocialState {}

class SocialListFailure extends HomeSocialState {
  final String errorMessage;
  SocialListFailure(this.errorMessage);
}

//Home page feeds
class MyFeedsInitial extends HomeSocialState {}

class MyFeedsListLoading extends HomeSocialState {}

class MyFeedsListSuccess extends HomeSocialState {}

class MyFeedsListFailure extends HomeSocialState {
  final String errorMessage;
  MyFeedsListFailure(this.errorMessage);
}

//Display request states
final class DisplayRequestCalled extends HomeSocialState {}

final class DisplayRequestSuccess extends HomeSocialState {}

final class DisplayRequestFailure extends HomeSocialState {
  final String message;
  DisplayRequestFailure(this.message);
}

// Search.
class HomeMusaSearchLoading extends HomeSocialState {}

class SearchUserListLoaded extends HomeSocialState {}

class SearchMusaSearchLoaded extends HomeSocialState {
  final SocialMusaListResponse myMusaList;

  SearchMusaSearchLoaded(this.myMusaList);
}

class SearchMusaSearchSuccess extends HomeSocialState {}

class HomeMusaSearchError extends HomeSocialState {
  final String errorMessage;
  HomeMusaSearchError(this.errorMessage);
}


class LikeUpdatedState extends HomeSocialState {
  final bool isLiked;
  final int likeCount;

  LikeUpdatedState({required this.isLiked, required this.likeCount});
}
