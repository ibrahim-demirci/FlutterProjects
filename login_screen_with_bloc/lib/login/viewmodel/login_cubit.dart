import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_screen_with_bloc/login/model/login_request_model.dart';
import 'package:login_screen_with_bloc/login/model/login_response.dart';
import 'package:login_screen_with_bloc/login/service/ILoginService.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  final ILoginService service;

  bool isLoginFail = false;
  bool isLoading = false;

  LoginCubit(this.formKey, this.emailController, this.passwordController, {required this.service}) : super(LoginInitial());

  void postUserModel() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      changeLoadingView();
      final data = await service.postUserLogin(
        LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
      changeLoadingView();
      if (data is LoginResponseModel) {
        emit(LoginComplete(data));
      }
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(LoginLoadingState(isLoading));
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginComplete extends LoginState {
  final LoginResponseModel model;

  LoginComplete(this.model);
}

class LoginValidateState extends LoginState {
  final bool isValite;

  LoginValidateState(this.isValite);
}

class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState(this.isLoading);
}
