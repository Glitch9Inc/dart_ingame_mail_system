class TimePeriod {
  final DateTime start;
  final DateTime end;

  const TimePeriod({required this.start, required this.end});

  factory TimePeriod.fromString(String timePeriod) {
    final split = timePeriod.split('~');
    return TimePeriod(start: DateTime.parse(split[0]), end: DateTime.parse(split[1]));
  }

  @override
  String toString() => '${start.toIso8601String()}~${end.toIso8601String()}';

  bool isBetween(DateTime time) => time.isAfter(start) && time.isBefore(end);
}
