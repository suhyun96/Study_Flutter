import 'package:flutter/material.dart';

// mixin  FishModel에 어떤 기능이 필요해서 ChangeNotifier 클래스를 mixin 사용

class SeaFishModel with ChangeNotifier{
  final String name;
  int tunaNumber;
  final String size;

  SeaFishModel({required this.name, required this.tunaNumber , required this.size});

  void changeSeaFishNumber(){
    tunaNumber++;
    // 알려줘야 리슨하고 있는 놈들이 알아차리고 데이터가 변함
    notifyListeners();
  }
}