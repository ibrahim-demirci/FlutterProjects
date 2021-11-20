import 'dart:io';

import 'package:dio/src/dio.dart';
import 'package:login_screen_with_bloc/login/model/login_request_model.dart';
import 'package:login_screen_with_bloc/login/model/login_response.dart';
import 'package:login_screen_with_bloc/login/service/ILoginService.dart';

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResponseModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);

    if (response.statusCode == HttpStatus.ok) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
