import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

// TickerProviderStateMixin : TabController 초기화를 하려면 vsync기능이 필요한데 TickerProviderStateMixin 요거 넣어야 할 수 있음
class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;

  // 민감도 기본값
  double threshold = 2.7;

  int number =1;

  ShakeDetector? shakeDetector;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 컨트롤러 초기화  vsync 때문에 TickerProviderStateMixin 이거 씀
    controller = TabController(length: 2, vsync: this);

    // 탭 버튼 누르는 등 변경사항이 있으면 addLisnter를 호출
    controller!.addListener(tabListener);

    // autoStart 생성자 사용시 코드 실행 순간부터 흔들기 감지
    shakeDetector = ShakeDetector.autoStart(
        shakeSlopTimeMS: 100, // 감지 주기
        shakeThresholdGravity: threshold, // 감지 민감도 : 슬라이더로 조절
        onPhoneShake: onPhoneShake, // 감지 시 호출할 콜백함수
    );
  }

  // 폰 흔들 때 실행
  void onPhoneShake(){
    final rand = new Random();

    setState(() {
      // 주사위 1 - 6
      number = rand.nextInt(5)+1;
    });
  }

  // 탭 컨트롤러의 속성 변경시 콜백되는 함수
  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      // 탭 네비게이션
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  //탭 화면 위젯들
  List<Widget> renderChildren() {
    return [
      HomeScreen(number: 1),
      SettingScreen(threshold: threshold, onThresholdChange: onThresholdChange)
    ];
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  //바텀용
  BottomNavigationBar renderBottomNavigation() {
    // 탭 네비게이션 바텀 위젯
    return BottomNavigationBar(
        currentIndex: controller!.index,
        onTap: (int index) {
          setState(() {
            controller!.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.edgesensor_high_outlined,
              ),
              label: '주사위'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: '설정'),
        ]);
  }
}
