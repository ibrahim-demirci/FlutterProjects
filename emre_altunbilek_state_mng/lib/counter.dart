
import 'package:flutter/material.dart';

class MyCounter with ChangeNotifier{

  int _sayac;


  int get sayac => _sayac;


  MyCounter(this._sayac);



  void arttir(){
    _sayac++;
    notifyListeners();
  }

  void azalt(){

    _sayac--;
    notifyListeners();

  }





}