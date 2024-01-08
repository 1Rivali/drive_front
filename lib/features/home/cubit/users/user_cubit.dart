import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drive_front/features/home/models/group_user.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void getGroupUsers(int groupId) async {
    try {
      emit(GetGroupUsersLoadingState());
      Response<dynamic>? response = await DioHelper.postAuthorized(
          path: '/group/users', data: {"id_group": groupId});
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

  void addUserToGroup({
    required String userId,
    required int groupId,
  }) async {
    try {
      emit(AddUserToGroupLoadingState());
      await DioHelper.postAuthorized(
          path: '/group/add/user',
          data: {"id_user": userId, "id_group": groupId});
      emit(AddUserToGroupSuccessState());
    } on DioException {
      emit(AddUserToGroupFailureState());
    } finally {
      getGroupUsers(groupId);
    }
  }
}
