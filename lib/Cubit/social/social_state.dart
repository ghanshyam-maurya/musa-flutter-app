import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';

class SocialState {}

class SocialListInitial extends SocialState {}

class SocialListLoading extends SocialState {}

class NextPageSocialListLoading extends SocialState {}

class SocialListSuccess extends SocialState {}

class SocialListSearchSuccess extends SocialState {}

class SocialListFailure extends SocialState {
  final String errorMessage;
  SocialListFailure(this.errorMessage);
}

//Home page feeds
class MyFeedsInitial extends SocialState {}

class MyFeedsListLoading extends SocialState {}

class MyFeedsListSuccess extends SocialState {}

class MyFeedsListFailure extends SocialState {
  final String errorMessage;
  MyFeedsListFailure(this.errorMessage);
}

//Display request states
final class DisplayRequestCalled extends SocialState {}

final class DisplayRequestSuccess extends SocialState {}

final class DisplayRequestFailure extends SocialState {
  final String message;
  DisplayRequestFailure(this.message);
}

// Search.
class HomeMusaSearchLoading extends SocialState {}

class SearchUserListLoaded extends SocialState {}

class SearchMusaSearchLoaded extends SocialState {
  final SocialMusaListResponse myMusaList;

  SearchMusaSearchLoaded(this.myMusaList);
}

class SearchMusaSearchSuccess extends SocialState {}

class HomeMusaSearchError extends SocialState {
  final String errorMessage;
  HomeMusaSearchError(this.errorMessage);
}

class LikeUpdatedState extends SocialState {
  final bool isLiked;
  final int likeCount;

  LikeUpdatedState({required this.isLiked, required this.likeCount});
}
