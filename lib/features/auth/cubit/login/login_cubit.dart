import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drive_front/features/auth/model/auth.dart';
import 'package:drive_front/utils/storage/cache_helper.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String username, required String password}) async {
    try {
      emit(LoginLoadingState());
      final Map<String, String> data = <String, String>{
        "user_name": username,
        "password": password,
      };
      Response<dynamic>? response =
          await DioHelper.postData(path: '/login', data: data);

      final AuthModel resUser = AuthModel.fromJson(response!.data['date']);
      await CacheHelper.setString(key: 'token', value: resUser.token!);
      await CacheHelper.setString(key: 'name', value: resUser.name!);
      await CacheHelper.setString(key: 'id', value: resUser.id!.toString());

      emit(LoginSuccessState());
    } on DioException catch (e) {
      print("response: ${e.response}");
      emit(LoginFailureState());
    }
  }
}
