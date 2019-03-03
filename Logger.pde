// ## Logger
// 
// Loggers can be added to objects to allow them to communicate in a 
// manageable way. Loggers are initialized with a log level and a prefix. 
// The logger will ignore messages below its level (ex: an INFO logger
// ignores debug messages). This is helpful so you can liberally fill
// your code with log messages and then quickly suppress them when you 
// no longer care to see them.

int DEBUG = 0, INFO = 1, WARNING = 2, ERROR = 3;

class Logger {
  int level;
  String prefix;
  String[] levelLabels = {"DEBUG", "INFO ", "WARN ", "ERROR"};
  
  Logger(int _level, String _prefix) {
    level = _level;
    prefix = _prefix;
  }
  
  void debug(String message) {
    if (level <= DEBUG) println(format(DEBUG, message)); 
  }
  void info(String message) {
    if (level <= INFO) println(format(INFO, message)); 
  }
  void warning(String message) {
    if (level <= WARNING) println(format(WARNING, message)); 
  }
  void error(String message) {
    if (level <= ERROR) println(format(ERROR, message)); 
  }
  String format(int msgLevel, String message) {
    return levelLabels[msgLevel] + " " + prefix + " " + message; 
  }
}
