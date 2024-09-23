import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:dart_ingame_mail_system/dart_ingame_mail_system.dart';

abstract class SystemMailConditionArgConverter {
  static int? convertToInt(String arg, String mailId, Logger logger) {
    try {
      return int.parse(arg);
    } catch (e) {
      logger.severe('System mail($mailId) condition argument($arg) is not a number');
      return null;
    }
  }

  static TimePeriod? convertToTimePeriod(String arg, String mailId, Logger logger) {
    try {
      return TimePeriod.fromString(arg);
    } catch (e) {
      logger.severe('System mail($mailId) condition argument($arg) is not a valid time period');
      return null;
    }
  }
}
