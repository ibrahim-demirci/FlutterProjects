// ignore: lowercase_with_underscores

// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:login_screen_with_bloc/login/model/login_request_model.dart';
import 'package:login_screen_with_bloc/login/model/login_response.dart';

abstract class ILoginService {
  final Dio dio;

  ILoginService(this.dio);

  final String loginPath = ILoginServicePath.LOGIN.rawValue;

  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model);
}

// ignore: constant_identifier_names
enum ILoginServicePath { LOGIN }

extension ILoginServicePathExtension on ILoginServicePath {
  String get rawValue {
    switch (this) {
      case ILoginServicePath.LOGIN:
        return '/login';
    }
  }
}
