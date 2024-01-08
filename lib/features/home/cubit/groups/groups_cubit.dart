import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drive_front/features/home/models/group.dart';
import 'package:drive_front/features/home/models/group_file.dart';
import 'package:drive_front/features/home/models/group_user.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());

  void createGroup(String gorupName) async {
    try {
      emit(CreateGroupLoadingState());
      await DioHelper.postAuthorized(path: '/group/create', data: {
        "name": gorupName,
      });
      emit(CreateGroupSuccessState());
    } on DioException catch (e) {
      emit(CreateGroupFailureState());
    }
  }

  void getMyGroups() async {
    try {
      emit(GetMyGroupsLoadingState());
      Response<dynamic>? response =
          await DioHelper.postAuthorized(path: '/group/myGroup');
      List<dynamic> groupsData = response!.data['date'];

      List<GroupModel> groups = groupsData
          .map((dynamic group) =>
              GroupModel.fromJson(group as Map<String, dynamic>))
          .toList();
      emit(GetMyGroupsSuccessState(groups: groups));
    } catch (e) {
      emit(GetMyGroupsFailureState());
    }
  }

  void getGroupFiles(int groupId) async {
    try {
      emit(GetGroupFilesLoadingState());
      Response<dynamic>? response = await DioHelper.postAuthorized(
          path: '/file/group', data: {"id_group": groupId});
      List<dynamic> filesData = response!.data;
      List<GroupFileModel> files = filesData
          .map((dynamic file) =>
              GroupFileModel.fromJson(file as Map<String, dynamic>))
          .toList();
      emit(GetGroupFilesSuccessState(files: files));
    } on DioException catch (e) {
      emit(GetGroupFilesFailureState());
    }
  }

  void getGroupUsers(String groupName) async {
    try {
      emit(GetGroupUsersLoadingState());
      Response<dynamic>? response = await DioHelper.postAuthorized(
          path: '/group/users', data: {"name": groupName});
      List<dynamic> userData = response!.data;
      List<GroupUserModel> users = userData
          .map((dynamic user) =>
              GroupUserModel.fromJson(user as Map<String, dynamic>))
          .toList();
      emit(GetGroupUsersSuccessState(users: users));
    } on DioException catch (e) {
      emit(GetGroupUsersFailureState());
    }
  }

  void createGroupFile(
      {required MultipartFile file,
      String? fileName,
      required int groupId}) async {
    try {
      emit(CreateGroupFileLoadingState());
      FormData data = FormData.fromMap({
        "file": file,
        "name_file": fileName ?? file.filename,
        "id_group": groupId,
      });
      await DioHelper.postAuthorized(path: '/file/group/create', data: data);
      emit(CreateGroupFileSuccessState());
    } on DioException catch (e) {
      emit(CreateGroupFileFailureState());
    } finally {
      getGroupFiles(groupId);
    }
  }

  void checkOutFile(int id) async {
    try {
      emit(CheckOutFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/check-out', data: {"id_file": id.toString()});

      emit(CheckOutFileSuccessState());
    } on DioException catch (e) {
      emit(CheckOutFileFailureState());
    }
  }

  void checkInFiles(List ids, int groupId) async {
    try {
      emit(CheckInFileLoadingState());
      await DioHelper.postAuthorized(
          path: '/file/bulk-check-in', data: {"ids": ids.toString()});
      emit(CheckInFileSuccessState());
    } on DioException catch (e) {
      emit(CheckInFileFailureState());
    } finally {
      getGroupFiles(groupId);
    }
  }
}
