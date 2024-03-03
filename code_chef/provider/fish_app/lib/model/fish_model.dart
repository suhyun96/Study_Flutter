import 'package:flutter/material.dart';

// mixin  FishModel에 어떤 기능이 필요해서 ChangeNotifier 클래스를 mixin 사용

class FishModel with ChangeNotifier{
   final String name;
   int number;
   final String size;

   FishModel({required this.name, required this.number , required this.size});

   void changeFishNumber(){
      number++;
      notifyListeners();
   }

}