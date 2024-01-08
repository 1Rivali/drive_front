part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class GetGroupUsersLoadingState extends UserState {}

class GetGroupUsersSuccessState extends UserState {
  final List<GroupUserModel> users;

  GetGroupUsersSuccessState({required this.users});
}

class GetGroupUsersFailureState extends UserState {}

class AddUserToGroupLoadingState extends UserState {}

class AddUserToGroupSuccessState extends UserState {}

class AddUserToGroupFailureState extends UserState {}
