import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';
import 'package:random_dice/screen/root_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // 배경색
      scaffoldBackgroundColor: backgroundColor,
      // 슬라이더 테마
      sliderTheme: SliderThemeData(
        thumbColor: primaryColor,
        activeTrackColor: primaryColor, // 활성화
        inactiveTrackColor: primaryColor.withOpacity(0.3), // 비활성화
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor, // 선택
        unselectedItemColor: secondaryColor, // 비선택
        backgroundColor: backgroundColor,
      )
    ),
    home: RootScreen(),
  ));
}
