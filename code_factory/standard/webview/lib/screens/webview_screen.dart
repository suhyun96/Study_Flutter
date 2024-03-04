import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {

  //webviewcontroller 선언
  WebViewController webViewController = WebViewController()
  //loadRequest로 설정된 페이지 이동
    ..loadRequest(Uri.parse('https://surunaru.tistory.com'))
    // 자바스크립트 허용
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('WebView'),
        // 타이틀 가운데 정렬
        centerTitle: true,

        //appbar에 액션 버튼 추가
        actions: [
          IconButton(
            onPressed: () {
              //버튼 누르면 콜백함수 호출되면서 아래 로직 실행 : 설정된 url로 페이지 전환
              webViewController
                  .loadRequest(Uri.parse('https://surunaru.tistory.com'));
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              // 뒤로 가기
              webViewController.goBack();
            },
            icon: const Icon(Icons.backspace),
          ),
          IconButton(
            onPressed: () {
              // 앞으로 가기
              webViewController.goForward();
            },
            icon: const Icon(Icons.forward),
          ),
        ],
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
