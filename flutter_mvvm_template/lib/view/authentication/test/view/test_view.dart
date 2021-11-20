import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mvvm_template/core/base/state/base_state.dart';
import 'package:flutter_mvvm_template/core/base/view/base_widget.dart';
import 'package:flutter_mvvm_template/core/init/lang/locale_keys.g.dart';
import 'package:flutter_mvvm_template/view/authentication/test/view-model/test_view_model.dart';
import 'package:mobx/mobx.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends BaseState<TestView> {
  TestViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<TestViewModel>(
      viewModel: TestViewModel(),
      onModelReady: (model) {
        viewModel = model;
      },
      onPageBuilder: (context, value) => Text("data"),
    );
  }

  Widget get scaffolBody => Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.welcome.tr()),
      ),
      floatingActionButton: floatingActionButtonNumberIncrement,
      body: textNumber);

  FloatingActionButton get floatingActionButtonNumberIncrement =>
      FloatingActionButton(
        onPressed: () => viewModel.incNum(),
      );

  Widget get textNumber {
    return Observer(
      builder: (context) => Text(viewModel.number.toString()),
    );
  }
}
