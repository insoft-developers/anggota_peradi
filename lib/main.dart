import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InAppWebViewController.setWebContentsDebuggingEnabled(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null) {
          bool canGoBack = await _controller!.canGoBack();
          if (canGoBack) {
            _controller!.goBack();
            return false; // ❗ jangan keluar app
          }
        }
        return true; // keluar app kalau sudah halaman awal
      },
      child: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('https://anggotaperadi.or.id'),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            domStorageEnabled: true,
            databaseEnabled: true,
            cacheEnabled: true,

            javaScriptCanOpenWindowsAutomatically: true,
            allowsInlineMediaPlayback: true,

            useShouldOverrideUrlLoading: false,
            supportZoom: false,
          ),
          onWebViewCreated: (controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
