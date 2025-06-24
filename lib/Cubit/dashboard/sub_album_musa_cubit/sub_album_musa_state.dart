abstract class SubAlbumMusaState {}

class SubAlbumMusaInitial extends SubAlbumMusaState {}

class SubAlbumMusaLoading extends SubAlbumMusaState {}

class SubAlbumMusaSuccess extends SubAlbumMusaState {}

class SubAlbumMusaFailure extends SubAlbumMusaState {
  final String errorMessage;
  SubAlbumMusaFailure(this.errorMessage);
} 