import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:peradi/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitPage(),
    );
  }
}

/// ⬅️ PAGE PENUNDA (PENTING)
class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool ready = false;

  @override
  void initState() {
    super.initState();

    /// ⛔ JANGAN buat WebView di initState langsung
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() => ready = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      /// ⬅️ ini penting, jangan return Container kosong
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const HomeView();
  }
}
