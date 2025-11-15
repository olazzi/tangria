import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tangria/core/log.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: '.env');
      await L.init(toFile: true);
      FlutterError.onError = (details) =>
          L.e('flutter_error', details.exception, details.stack);
      PlatformDispatcher.instance.onError = (error, stack) {
        L.e('platform_error', error, stack);
        return true;
      };
      runApp(const TangriaApp());
    },
    (e, s) {
      L.e('zone_error', e, s);
    },
  );
}

class TangriaApp extends StatelessWidget {
  const TangriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morbi',
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.black.withOpacity(0.08),
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(color: Colors.black87),
          ),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          surfaceTintColor: Colors.transparent,
          elevation: 1,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
