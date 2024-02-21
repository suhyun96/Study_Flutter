import 'package:flutter/material.dart';
import 'package:splash_screen.dart/screen/splash_screen.dart';

void main() {
  //화면 전체에 SplashScreen위젯을 그릴 거니까 runApp의 매개변수로 넣어준다
  runApp(const MaterialApp(
    home: Scaffold(
      body: SplashScreen(),
    ),
  ));
}
