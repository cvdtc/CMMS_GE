import 'dart:async';
import 'dart:io';

import 'package:cmmsge/utils/warna.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScanResult extends StatefulWidget {
  String urlwebview, token;
  WebviewScanResult({required this.urlwebview, required this.token});

  @override
  _WebviewScanResultState createState() => _WebviewScanResultState();
}

class _WebviewScanResultState extends State<WebviewScanResult> {
  String urlweb = "";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late SharedPreferences sp;
  String? token = "";

  @override
  void initState() {
    urlweb = 'https://produksi.grand-elephant.co.id/datamasalah.php?nomesin=' +
        widget.urlwebview +
        '&&token=' +
        widget.token.toString();
    final _key = UniqueKey();
    print('WEBVIEW? ' + urlweb + ' ~ ' + _key.toString());
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Mesin'),
          centerTitle: true,
          backgroundColor: thirdcolor,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: urlweb,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          );
        }));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
