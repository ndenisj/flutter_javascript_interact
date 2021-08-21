import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebview extends StatefulWidget {
  @override
  _SimpleWebviewState createState() => _SimpleWebviewState();
}

class _SimpleWebviewState extends State<SimpleWebview> {
  WebViewController _controller;
  bool isLoading = true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Wallet Funding"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildWebView(),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _controller.evaluateJavascript(
          //     'changeImagePathWith("https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png");');
          _controller.evaluateJavascript('getAmount("200");');
          _controller.evaluateJavascript('getEmail("denis@email.com");');
          _controller.evaluateJavascript('getName("Denison");');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildWebView() {
    return WebView(
      key: _key,
      initialUrl: "https://evth.lektiapay.com/flutterhome",
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
        // _loadLocalHtmlFile();
      },
      onPageFinished: (String url) {
        // print('Page finished loading: $url');
        setState(() {
          isLoading = false;
        });
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>[
        _messageJavascriptChannel(context),
        _scriptJavascriptChannel(context),
      ].toSet(),
    );
  }

  JavascriptChannel _messageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        });
  }

  JavascriptChannel _scriptJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Postascript',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print(message.message);
        });
  }

  _loadLocalHtmlFile() async {
    String fileText = await rootBundle.loadString('assets/web/index.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
