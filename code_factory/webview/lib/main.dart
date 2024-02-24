import 'package:flutter/material.dart';
import 'package:webview/screens/webview_screen.dart';

void main() {

  //플러터 프레임워크가 앱 실행할 준비가 될 때까지 대기
  //stateless 위젯에서 WebViewController의 프로퍼티를 인스턴스화하려면 해당 함수를 직접 실행해야한다고 한다
  //statefull이었으면 initState()에서 초기화하면 되는데 여긴 그게 안 되니까
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: WebViewScreen(),
  ));
}
