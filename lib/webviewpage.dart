import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String pageUrl;
  final String judul;
  const WebViewPage({super.key, required this.pageUrl, required this.judul});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? controller;
  late PullToRefreshController pullToRefreshController;
  bool isLoading = true; // untuk loading indicator

  @override
  void initState() {
    super.initState();

    // 🔹 Init PullToRefreshController
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: const Color(0xFF0D47A1), // warna loading indicator
      ),
      onRefresh: () async {
        if (controller != null) {
          try {
            await controller!.reload();
          } catch (_) {}
        }
      },
    );
  }

  @override
  void dispose() {
    pullToRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.judul,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white), // panah back putih
      ),
      backgroundColor: Colors.white, // WAJIB di iOS
      body: SafeArea(
        child: Stack(
          children: [
            // 1️⃣ Placeholder background
            Container(color: Colors.white),

            // 2️⃣ WebView dengan Pull-to-Refresh
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.pageUrl)),
              pullToRefreshController: pullToRefreshController,
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                databaseEnabled: true,
                cacheEnabled: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
                transparentBackground: false, // WAJIB supaya placeholder muncul
              ),
              onWebViewCreated: (controller) => this.controller = controller,
              onLoadStart: (controller, url) {
                setState(() => isLoading = true);
              },
              onLoadStop: (controller, url) async {
                setState(() => isLoading = false);
                pullToRefreshController.endRefreshing();
              },
              onLoadError: (controller, url, code, msg) {
                setState(() => isLoading = false);
                pullToRefreshController.endRefreshing();
              },
            ),

            // 3️⃣ Loading indicator
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
