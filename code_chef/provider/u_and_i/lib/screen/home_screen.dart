import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DDay(
                onHeartPressed: onHeartPressed,
                firstDay: firstDay,
              ),
              _CoupleImage(),
            ],
          ),
        ));
  }

  void onHeartPressed() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        // 정렬 전용 위젯 Align
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300.0,
            child: CupertinoDatePicker(
                // 미래 시간 설정 못 하도록
                maximumDate: endOfDay,
                mode: CupertinoDatePickerMode.date,
                // 다이얼로그에서 선택한 날짜를 date 매개변수로 받음
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    firstDay = date;
                  });
                }),
          ),
        );
      },
      // 외부 탭 할 때 다이얼로그 닫기
      barrierDismissible: true,
    );

    // setState로 실행지 build함수가 새롭게 빌드되며 랜더링
    // setState(() {
    //   print('firstDay : $firstDay');
    //   firstDay = firstDay.subtract(Duration(days: 1));
    // });
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay({
    super.key,
    required this.onHeartPressed,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Text(
          'U&I',
          style: textTheme.headline1,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          '우리 처음 만난 날',
          style: textTheme.bodyText1,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyText2,
        ),
        const SizedBox(
          height: 16.0,
        ),
        IconButton(
          iconSize: 60.0,
          onPressed: onHeartPressed,
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          'D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}',
          style: textTheme.headline2,
        ),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  const _CoupleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          'asset/img/couple.png',
          // Expanded로 감쌌으니까 주석처리
          // height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
