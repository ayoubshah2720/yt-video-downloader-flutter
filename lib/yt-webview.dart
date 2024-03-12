import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yt_video_demo/download.dart';

class YtWebview extends StatefulWidget {
  const YtWebview({super.key});

  @override
  State<YtWebview> createState() => _YtWebviewState();
}

class _YtWebviewState extends State<YtWebview> {
  final link = 'https://www.youtube.com';
  WebViewController? _controller;
  bool _showDownloadButton = false;

  void checkURL() async {
    if (await _controller!.currentUrl() == 'https://www.youtube.com') {
      setState(() {
        _showDownloadButton = false;
      });
    } else {
      setState(() {
        _showDownloadButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkURL();
    return WillPopScope(
      onWillPop: () async {
        if (await _controller!.canGoBack()) {
          _controller!.goBack();
        }
        return true;
      },
      child: Scaffold(
        body: WebView(
          initialUrl: link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (contoller) {
            setState(() {
              _controller = contoller;
            });
          },
        ),
        floatingActionButton: _showDownloadButton == false
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  final url = await _controller!.currentUrl();
                  final title = await _controller!.getTitle();
                  Download().downloadVideo(url!, '$title');
                },
                child: Icon(Icons.download),
              ),
      ),
    );
  }
}
