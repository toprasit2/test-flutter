import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebViewScreen extends StatefulWidget {
  TestWebViewScreen({Key key, this.title = "Test Web View"}) : super(key: key);

  // This widget is the home Screen of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _TestWebViewScreenState createState() => _TestWebViewScreenState();
}

class _TestWebViewScreenState extends State<TestWebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          width: width,
          height: height,
          child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              _webViewController = webViewController;
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl:
                "https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebView-class.html",
            javascriptChannels: {
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    print(message.message);
                  })
            },
          ),
        ),
        floatingActionButton: favoriteButton());
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}
