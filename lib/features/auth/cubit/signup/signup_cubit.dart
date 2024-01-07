import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:drive_front/features/auth/model/auth.dart';
import 'package:drive_front/features/auth/model/signup.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:drive_front/utils/storage/cache_helper.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  void signup(SignupModel user) async {
    try {
      emit(SignupLoadingState());
      final Map<String, dynamic> data = user.toJson();
      Response<dynamic>? response = await DioHelper.postData(
        path: '/register',
        data: data,
      );
      final AuthModel resUser = AuthModel.fromJson(response!.data['date']);
      await CacheHelper.setString(key: 'token', value: resUser.token!);
      await CacheHelper.setString(key: 'name', value: resUser.name!);
      await CacheHelper.setString(key: 'id', value: resUser.id!.toString());
      emit(SignupSuccessState());
    } on DioException catch (e) {
      print("response: ${e.response}");
      emit(SignupFailureState());
    }
  }
}
