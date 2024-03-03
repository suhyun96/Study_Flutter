import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fish_app/model/fish_model.dart';
import '../model/seafish_model.dart';
import 'fish_order.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  // 지금 build함수 내에서 사용하는 context는 provider 위젯의 위에 위치하니까 HomeScreen부터 타고 올라가니까 에러가 난다.
  // Builder로 감싸줘야함
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                FishModel(name: 'Salmon', number: 10, size: 'big'),
          ),
          ChangeNotifierProvider(
            create: (context) => SeaFishModel(
              name: 'Tuna',
              tunaNumber: 0,
              size: 'middle',
            ),
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Fish Order'),
            backgroundColor: Colors.orange,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                FishOrder(),
                const SizedBox(
                  height: 20,
                ),
                //context 때문에 사용
                Builder(builder: (ctx) {
                  return ElevatedButton(
                    onPressed: () {
                      Provider.of<FishModel>(ctx, listen: false).number=0;
                      // 알려줘야 바뀐다. 그리고 보통 이렇게 쓰지 않고 모델 함수 내에서 사용하는 게 맞다
                      Provider.of<FishModel>(ctx, listen: false).notifyListeners();
                      Provider.of<SeaFishModel>(ctx, listen: false)
                          .changeSeaFishNumber();
                    },
                    child: Text('total - button'),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
