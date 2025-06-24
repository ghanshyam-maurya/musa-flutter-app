import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final String musaId;
  final bool isLiked;
  final int likeCount;

  const LikeState({required this.musaId, required this.isLiked, required this.likeCount});

  @override
  List<Object> get props => [musaId, isLiked, likeCount];
}

class LikeCubit extends Cubit<LikeState?> {
  LikeCubit() : super(null);

  void toggleLike({required String musaId, required bool currentLikeStatus, required int likeCount}) {
    final newLikeStatus = !currentLikeStatus;
    final newLikeCount = newLikeStatus ? likeCount + 1 : likeCount - 1;

    emit(LikeState(musaId: musaId, isLiked: newLikeStatus, likeCount: newLikeCount));
  }
}
