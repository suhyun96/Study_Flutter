import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';

class SettingScreen extends StatelessWidget {
  // 슬라이더의 현재값
  final double threshold;

  // 슬라이더 변경될 때마다 실행되는 함수
  final ValueChanged<double> onThresholdChange;

  const SettingScreen(
      {super.key, required this.threshold, required this.onThresholdChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text(
                '민감도',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Slider(
          // 슬라이더 최솟값
          min: 0.1,
          // 슬라이더 최댓값
          max: 10.0,
          // 최솟값과 최댓값 사이 구간 갯수
          divisions: 101,
          // 슬라이더 선택값
          value: threshold,
          // 슬라이더 조작시 실행되는 함수
          onChanged: onThresholdChange,
          // 슬라이더 표시 값
          label: threshold.toStringAsFixed(1),
        ),
      ],
    );
  }
}
