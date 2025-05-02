import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) async{
                if (request.url.startsWith(
                  'http://10.0.2.2:8080/login/oauth2/code/naver',
                )) {
                  final uri = Uri.parse(request.url);
                  final code = uri.queryParameters['code'];
                  final state = uri.queryParameters['state'];
                  Dio dio = Dio();
                  final resp = await dio.get(
                    'http://10.0.2.2:8080/oauth2/naver/token',
                    options: Options(headers: {'code': code, 'state': state}),
                  );
                  print(resp.data);
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url));
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
