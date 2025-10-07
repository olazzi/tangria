import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tangria/core/log.dart';
import 'screens/home/home_screen.dart';
import 'screens/history_screen.dart';

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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
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
  final _pages = const [HomeScreen(), HistoryScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_i],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (v) => setState(() => _i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Analyze'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
