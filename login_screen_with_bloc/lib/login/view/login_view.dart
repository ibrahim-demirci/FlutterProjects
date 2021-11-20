import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen_with_bloc/login/service/login_service.dart';
import 'package:login_screen_with_bloc/login/view/login_detail_view.dart';
import 'package:login_screen_with_bloc/login/viewmodel/login_cubit.dart';

class LoginView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String baseUrl = 'https://reqres.in/api';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(formKey, emailController, passwordController,
          service: LoginService(
            Dio(BaseOptions(baseUrl: baseUrl)),
          )),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginComplete) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginDetailView(model: state.model),
              ),
            );
          }
        },
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: _appBar(context),
      body: Form(
        key: formKey,
        autovalidateMode:
            state is LoginValidateState ? (state.isValite ? AutovalidateMode.always : AutovalidateMode.disabled) : AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textFormFieldEmail(),
            const SizedBox(height: 20),
            textFormFieldPassword(),
            const SizedBox(height: 10),
            _elevatedButton(context),
          ],
        ),
      ),
    );
  }

  BlocConsumer<LoginCubit, LoginState> _elevatedButton(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginComplete) {
          return const Card(
            child: Icon(Icons.check),
          );
        }
        return ElevatedButton(
            onPressed: context.watch<LoginCubit>().isLoading
                ? null
                : () {
                    context.read<LoginCubit>().postUserModel();
                  },
            child: const Text('Save'));
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        title: const Text('Cubit Login'),
        leading: Visibility(
          visible: context.watch<LoginCubit>().isLoading,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ));
  }

  TextFormField textFormFieldEmail() {
    return TextFormField(
      controller: emailController,
      validator: (value) => (value ?? '').length > 5 ? null : 'Less than 5 characters',
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
    );
  }

  TextFormField textFormFieldPassword() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => (value ?? '').length > 6 ? null : 'Less than 6 haracters',
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
    );
  }
}
