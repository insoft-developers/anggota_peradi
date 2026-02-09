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
  PullToRefreshController? pullToRefreshController;
  bool isLoading = true;
  bool isDisposed = false; // <<< PENJAGA

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: const Color(0xFF0D47A1),
      ),
      onRefresh: () async {
        if (isDisposed) return;
        try {
          await controller?.reload();
        } catch (_) {}
      },
    );
  }

  @override
  void dispose() {
    isDisposed = true; // <<< tandai sudah mati
    controller = null;
    pullToRefreshController = null;
    super.dispose();
  }

  void stopRefresh() {
    if (isDisposed) return;
    try {
      pullToRefreshController?.endRefreshing();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),
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
                transparentBackground: false,
              ),
              onWebViewCreated: (c) => controller = c,
              onLoadStart: (c, url) {
                if (isDisposed) return;
                setState(() => isLoading = true);
              },
              onLoadStop: (c, url) async {
                if (isDisposed) return;
                setState(() => isLoading = false);
                stopRefresh();
              },
              onLoadError: (c, url, code, msg) {
                if (isDisposed) return;
                setState(() => isLoading = false);
                stopRefresh();
              },
            ),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
