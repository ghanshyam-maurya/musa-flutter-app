import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';

class ArtSocialState {}

class SocialListInitial extends ArtSocialState {}

class SocialListLoading extends ArtSocialState {}

class NextPageSocialListLoading extends ArtSocialState {}

class SocialListSuccess extends ArtSocialState {}

class SocialListSearchSuccess extends ArtSocialState {}

class SocialListFailure extends ArtSocialState {
  final String errorMessage;
  SocialListFailure(this.errorMessage);
}

//Home page feeds
class MyFeedsInitial extends ArtSocialState {}

class MyFeedsListLoading extends ArtSocialState {}

class MyFeedsListSuccess extends ArtSocialState {}

class MyFeedsListFailure extends ArtSocialState {
  final String errorMessage;
  MyFeedsListFailure(this.errorMessage);
}

//Display request states
final class DisplayRequestCalled extends ArtSocialState {}

final class DisplayRequestSuccess extends ArtSocialState {}

final class DisplayRequestFailure extends ArtSocialState {
  final String message;
  DisplayRequestFailure(this.message);
}

// Search.
class HomeMusaSearchLoading extends ArtSocialState {}

class SearchUserListLoaded extends ArtSocialState {}

class SearchMusaSearchLoaded extends ArtSocialState {
  final SocialMusaListResponse myMusaList;

  SearchMusaSearchLoaded(this.myMusaList);
}

class SearchMusaSearchSuccess extends ArtSocialState {}

class HomeMusaSearchError extends ArtSocialState {
  final String errorMessage;
  HomeMusaSearchError(this.errorMessage);
}

class LikeUpdatedState extends ArtSocialState {
  final bool isLiked;
  final int likeCount;

  LikeUpdatedState({required this.isLiked, required this.likeCount});
}
