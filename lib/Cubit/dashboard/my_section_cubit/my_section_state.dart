class MySectionState {}

class MySectionInitial extends MySectionState{}

class MySectionLoading extends MySectionState{}

class MySectionSuccess extends MySectionState{}

class MySectionFailure extends MySectionState{}

class MyAlbumInitial extends MySectionState{}

class MyAlbumLoading extends MySectionState{}

class MyAlbumSuccess extends MySectionState{}

class MyAlbumFailure extends MySectionState{
  final String errorMessage;
  MyAlbumFailure(this.errorMessage);
}

class MySubAlbumInitial extends MySectionState{}

class MySubAlbumLoading extends MySectionState{}

class MySubAlbumSuccess extends MySectionState{}

class MySubAlbumFailure extends MySectionState{
  final String errorMessage;
  MySubAlbumFailure(this.errorMessage);
}

class MyLibraryLoading extends MySectionState{}

class MyLibrarySuccess extends MySectionState{}

class MyLibraryFailure extends MySectionState{
  final String errorMessage;
  MyLibraryFailure(this.errorMessage);
}

class TabUpdated extends MySectionState{}
class MySectionLoadedState extends MySectionState{
  final data;
  MySectionLoadedState(this.data);
}