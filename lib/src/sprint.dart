import 'package:tint/tint.dart';

import 'package:sprint/src/level.dart';

/// Defines the signature of a function responsible for logging to the terminal
/// or console.
typedef LogFunction = void Function(dynamic message, {Level level});

/// Determines whether the program is running in a JavaScript environment.
const isWeb = identical(0, 0.0);

/// Maps logging levels to the methods that colour them.
final colorMappings = <Level, String Function(String)>{
  Level.debug: (string) => string.gray(),
  Level.success: (string) => string.green(),
  Level.info: (string) => string.cyan(),
  Level.warn: (string) => string.yellow(),
  Level.severe: (string) => string.red(),
  Level.fatal: (string) => string.red().onYellow(),
};

/// Printing API that allows for simple printing of messages.
class Sprint {
  /// An identifier of the code in charge of this `Sprint` instance.
  final String owner;

  /// When set to true, debug messages will not be displayed.
  final bool productionMode;

  /// When set to true, no messages will be displayed.
  bool quietMode;

  /// When set to true, a timestamp will be included with the printed message.
  final bool includeTimestamp;

  /// Create an instance of `Sprint`, indicated as belonging to [owner].
  ///
  /// [includeTimestamp] - Whether to include a timestamp with the message.
  ///
  /// [productionMode] - Whether the project using `Sprint` is in production
  /// mode, thus stopping the printing of `Severity.debug` messages.
  ///
  /// [quietMode] - Whether the printing of messages should be stopped entirely.
  Sprint(
    this.owner, {
    this.includeTimestamp = false,
    this.productionMode = false,
    this.quietMode = false,
  }) {
    log = isWeb ? _printToConsole : _printToTerminal;
  }

  /// Prints a message to the web console or to the terminal.
  late final LogFunction log;

  /// Obtains a timestamp if [includeTimestamp] is `true`.
  String get timestamp => includeTimestamp ? '[${DateTime.now()}] ' : '';

  /// Formats a message with a timestamp and the owner of the `Sprint` instance.
  String format(dynamic message) {
    final content =
        message.toString().replaceAll('\n', '\n${' ' * (3 + owner.length)}');
    return '$timestamp<$owner> $content';
  }

  void _printToConsole(dynamic message, {Level level = Level.info}) {
    if (quietMode) {
      return;
    }

    print(format(message));
  }

  void _printToTerminal(dynamic message, {Level level = Level.info}) {
    if (quietMode) {
      return;
    }

    print(format(colorMappings[level]!(message.toString())));
  }

  /// Prints a debug message.
  void debug(dynamic message) => log(message, level: Level.debug);

  /// Alias for `debug()`.
  void d(dynamic message) => debug(message);

  /// Prints a success message.
  void success(dynamic message) => log(message, level: Level.success);

  /// Alias for `success()`.
  void s(dynamic message) => success(message);

  /// Prints an informational message.
  void info(dynamic message) => log(message);

  /// Alias for `info()`.
  void information(dynamic message) => info(message);

  /// Alias for `info()`.
  void i(dynamic message) => info(message);

  /// Prints a warning message.
  void warn(dynamic message) => log(message, level: Level.warn);

  /// Alias for `warn()`.
  void warning(dynamic message) => warn(message);

  /// Alias for `warn()`.
  void w(dynamic message) => warn(message);

  /// Prints a severe message.
  void severe(dynamic message) => log(message, level: Level.severe);

  /// Alias for `severe()`.
  void sv(dynamic message) => severe(message);

  /// Prints a fatal message.
  void fatal(dynamic message) => log(message, level: Level.fatal);

  /// Alias for `fatal()`.
  void f(dynamic message) => fatal(message);

  /// A call on the instance itself is synonymous with an `info()` call.
  void call(dynamic message) => info(message);
}
