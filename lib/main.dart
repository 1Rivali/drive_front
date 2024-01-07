import 'dart:developer';

import 'package:drive_front/config/theme/app_theme.dart';
import 'package:drive_front/features/auth/screens/login/login.dart';
import 'package:drive_front/features/auth/screens/signup/signup.dart';
import 'package:drive_front/features/home/cubit/home_cubit.dart';
import 'package:drive_front/features/home/screens/home.dart';
import 'package:drive_front/utils/storage/cache_helper.dart';
import 'package:drive_front/utils/network/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: 'token');
    log(token.toString());
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: MaterialApp(
        title: "Drive",
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: token != null ? '/' : '/login',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
        },
      ),
    );
  }
}
