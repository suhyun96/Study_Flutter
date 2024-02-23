import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            //color: Colors.orange,
            color: Color(0xFFF99231),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/rupy.png',
                    width: 300,
                    height: 300,
                  ),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(Scaffold.of(ctx).hasAppBar);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('hello'),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
