import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class L {
  static Logger? _l;
  static Future<void> init({bool toFile = false}) async {
    final outputs = <LogOutput>[ConsoleOutput()];
    if (toFile) {
      final dir = await getApplicationSupportDirectory();
      final f = File(p.join(dir.path, 'app_data', 'logs', 'app.log'));
      await f.parent.create(recursive: true);
      outputs.add(FileOutput(file: f));
    }
    _l = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      level: Level.debug,
      output: MultiOutput(outputs),
    );
  }

  static void d(String m, [dynamic d]) => _l?.d({'msg': m, 'data': d});
  static void i(String m, [dynamic d]) => _l?.i({'msg': m, 'data': d});
  static void w(String m, [dynamic d]) => _l?.w({'msg': m, 'data': d});
static void e(String m, [dynamic d, StackTrace? s]) =>
    _l?.e({'msg': m, 'data': d}, error: d, stackTrace: s);

}
