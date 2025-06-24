class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {}
class CommentLikeLoaded extends CommentState {}

class CommentSuccess extends CommentState {}

class CommentUpdated extends CommentState {
  final int? count;
  CommentUpdated({required this.count});
}

class CommentFailure extends CommentState {
  final String? errorMessage;
  CommentFailure({required this.errorMessage});
}
