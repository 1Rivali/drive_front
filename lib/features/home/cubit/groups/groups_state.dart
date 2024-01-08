part of 'groups_cubit.dart';

@immutable
sealed class GroupsState {}

final class GroupsInitial extends GroupsState {}

class CreateGroupLoadingState extends GroupsState {}

class CreateGroupSuccessState extends GroupsState {}

class CreateGroupFailureState extends GroupsState {}

class GetMyGroupsLoadingState extends GroupsState {}

class GetMyGroupsSuccessState extends GroupsState {
  final List<GroupModel> groups;

  GetMyGroupsSuccessState({required this.groups});
}

class GetMyGroupsFailureState extends GroupsState {}

class GetGroupFilesLoadingState extends GroupsState {}

class GetGroupFilesSuccessState extends GroupsState {
  final List<GroupFileModel> files;

  GetGroupFilesSuccessState({required this.files});
}

class GetGroupFilesFailureState extends GroupsState {}

class GetGroupUsersLoadingState extends GroupsState {}

class GetGroupUsersSuccessState extends GroupsState {
  final List<GroupUserModel> users;

  GetGroupUsersSuccessState({required this.users});
}

class GetGroupUsersFailureState extends GroupsState {}

class CreateGroupFileLoadingState extends GroupsState {}

class CreateGroupFileSuccessState extends GroupsState {}

class CreateGroupFileFailureState extends GroupsState {}

class CheckOutFileLoadingState extends GroupsState {}

class CheckOutFileSuccessState extends GroupsState {}

class CheckOutFileFailureState extends GroupsState {}

class CheckInFileLoadingState extends GroupsState {}

class CheckInFileSuccessState extends GroupsState {}

class CheckInFileFailureState extends GroupsState {}
