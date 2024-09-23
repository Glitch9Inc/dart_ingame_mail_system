abstract class InGameMailId {
  static String create(DateTime dateTime) {
    return 'mail_${dateTime.millisecondsSinceEpoch}';
  }
}
