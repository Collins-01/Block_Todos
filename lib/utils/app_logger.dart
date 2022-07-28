import 'package:simple_logger/simple_logger.dart';

class AppLogger {
  static final _logger = SimpleLogger();
  static log(dynamic message) {
    _logger.setLevel(
      Level.FINEST,
      stackTraceLevel: Level.INFO,
      includeCallerInfo: false,
    );
    _logger.info(message);
  }
  //
}
