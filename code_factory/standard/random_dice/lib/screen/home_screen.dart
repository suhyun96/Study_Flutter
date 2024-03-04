import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/colors.dart';

class HomeScreen extends StatelessWidget {
  final int number;

  const HomeScreen({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset('asset/img/dice$number.svg',
          width: 200,
          height: 200,),
        ),
        SizedBox(
          height: 32.0,
        ),
        Text(
          '행운의 숫자',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          number.toString(),
          style: TextStyle(
            color: primaryColor,
            fontSize: 60,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
