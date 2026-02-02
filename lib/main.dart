import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
/// BOOTSTRAP (ANTI STUCK iOS)
/// ===============================
class WebViewBootstrap extends StatefulWidget {
  const WebViewBootstrap({super.key});

  @override
  State<WebViewBootstrap> createState() => _WebViewBootstrapState();
}

class _WebViewBootstrapState extends State<WebViewBootstrap> {
  bool ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
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
  bool _error = false;

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
          child: _error
              ? const Center(
                  child: Text(
                    'Gagal memuat halaman.\nPeriksa koneksi internet.',
                    textAlign: TextAlign.center,
                  ),
                )
              : InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri('https://anggotaperadi.or.id'),
                  ),
                  initialSettings: InAppWebViewSettings(
                    // 🔥 WAJIB iOS
                    useShouldOverrideUrlLoading: true,
                    allowsInlineMediaPlayback: true,
                    mediaPlaybackRequiresUserGesture: false,

                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    cacheEnabled: true,

                    // 🔥 PENTING untuk iOS putih
                    allowsBackForwardNavigationGestures: true,
                    useOnLoadResource: true,
                  ),
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onLoadError: (controller, url, code, message) {
                    setState(() => _error = true);
                  },
                  onLoadHttpError: (controller, url, statusCode, description) {
                    setState(() => _error = true);
                  },
                ),
        ),
      ),
    );
  }
}
