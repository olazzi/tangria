// lib/main.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tangria/core/log.dart';
import 'screens/home/home_screen.dart';
import 'screens/collection/collection_screen.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await L.init(toFile: true);
    FlutterError.onError = (details) => L.e('flutter_error', details.exception, details.stack);
    PlatformDispatcher.instance.onError = (error, stack) {
      L.e('platform_error', error, stack);
      return true;
    };
    runApp(const TangriaApp());
  }, (e, s) {
    L.e('zone_error', e, s);
  });
}

class TangriaApp extends StatelessWidget {
  const TangriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tangria',
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.black.withOpacity(0.08),
          iconTheme: const WidgetStatePropertyAll(IconThemeData(color: Colors.black87)),
          labelTextStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
          surfaceTintColor: Colors.transparent,
          elevation: 1,
        ),
      ),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _i = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomeScreen(),
      CollectionScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _i,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (v) => setState(() => _i = v),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_outlined),
            selectedIcon: Icon(Icons.collections),
            label: 'My Collection',
          ),
        ],
      ),
    );
  }
}
