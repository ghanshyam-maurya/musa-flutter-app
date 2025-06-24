import 'package:equatable/equatable.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

final class ChatListInitial extends ChatListState {}

final class ChatListSelected extends ChatListState {}

final class ChatListLoading extends ChatListState {}

final class ChatListFetched extends ChatListState {}

final class ChatDeleted extends ChatListState {}

final class ChatMediaLoaded extends ChatListState {}

final class ChatMediaSuccess extends ChatListState {}

final class ChatListNoInternetCheck extends ChatListState {}

final class ChatListError extends ChatListState {
  final String? errorMessage;
  const ChatListError({required this.errorMessage});
}
