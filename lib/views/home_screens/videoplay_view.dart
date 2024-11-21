import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayView extends StatefulWidget {
  final String url;

  const VideoPlayView({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayViewState createState() => _VideoPlayViewState();
}

class _VideoPlayViewState extends State<VideoPlayView> {
  var loadingPercentage = 0;
  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DemCare Fitness Tutorials',
          style: TextStyle(
            color: Color(0xFF432C81),
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
