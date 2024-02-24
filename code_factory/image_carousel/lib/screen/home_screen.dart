import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // 생성자가 State를 생성해서 반환한다.
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //PageView를 제어할 컨트롤러 생성
  final PageController pageController = PageController();

  //앱이 최초 랜더링 될 때 단 한 번만 실행
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 상태바 색상 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    //타이머를 세팅해서 주기적으로 실행되도록 설정
    //build에 넣어두면 새로 만들 때마다 새롭게 빌드되어버려서 initState에 정의
    Timer.periodic(const Duration(seconds: 3), (timer) {
      // 다음 페이지가 무엇인지 컨트롤러에서 페이지를 찾는다
      int? nextPage = pageController.page?.toInt();

      if (nextPage == null) {
        return;
      }

      if (nextPage == 4) {
        nextPage = 0;
      } else {
        nextPage++;
      }

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: SafeArea(
        top: true,
        child: PageView(
          controller: pageController,
          children: [1, 2, 3, 4, 5]
              .map(
                (num) => Image.asset(
                  'asset/img/$num.png',
                  //fit: BoxFit.cover,
                  fit: BoxFit.fitWidth
                ),
              )
          // children은 위젯 리스트로 전해줘야한다.
              .toList(),
        ),
      ),
    );
  }
}
