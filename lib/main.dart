import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // kunci portrait dulu, aman untuk iOS
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewBootstrap(),
    );
  }
}

/// ===============================
/// BOOTSTRAP PAGE (ANTI STUCK)
/// ===============================
class WebViewBootstrap extends StatefulWidget {
  const WebViewBootstrap({super.key});

  @override
  State<WebViewBootstrap> createState() => _WebViewBootstrapState();
}

class _WebViewBootstrapState extends State<WebViewBootstrap> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();

    /// 🔥 TUNDA logic sampai frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initApp();
    });
  }

  Future<void> _initApp() async {
    // kalau nanti mau nambah SharedPreferences / token / dll
    // taruh DI SINI

    if (!mounted) return;
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      /// simple splash (aman iOS)
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const WebViewPage();
  }
}

/// ===============================
/// WEBVIEW PAGE
/// ===============================
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
        if (_controller != null && await _controller!.canGoBack()) {
          _controller!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://anggotaperadi.or.id'),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              cacheEnabled: true,
              allowsInlineMediaPlayback: true,
              mediaPlaybackRequiresUserGesture: false,
              javaScriptCanOpenWindowsAutomatically: true,
              useShouldOverrideUrlLoading: true,
              supportZoom: false,
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
            },
          ),
        ),
      ),
    );
  }
}
