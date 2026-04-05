class BeepTestLevelData {
  final int level;
  final int shuttles;
  final double speedKmh;
  final double timePerShuttleSec;
  final double cumulativeTimeSec;
  final int cumulativeDistanceM;

  const BeepTestLevelData({
    required this.level,
    required this.shuttles,
    required this.speedKmh,
    required this.timePerShuttleSec,
    required this.cumulativeTimeSec,
    required this.cumulativeDistanceM,
  });
}

class BeepTestResultData {
  final int level;
  final int shuttle;
  final double speedKmh;
  final double totalTimeSec;
  final int totalDistanceM;
  final double continuousScore;
  final double? vo2maxMlKgMin;

  const BeepTestResultData({
    required this.level,
    required this.shuttle,
    required this.speedKmh,
    required this.totalTimeSec,
    required this.totalDistanceM,
    required this.continuousScore,
    required this.vo2maxMlKgMin,
  });
}

class BeepTestTable {
  static const Map<int, BeepTestLevelData> levels = {
    1: BeepTestLevelData(
      level: 1,
      shuttles: 7,
      speedKmh: 8.0,
      timePerShuttleSec: 9.00,
      cumulativeTimeSec: 63.0,
      cumulativeDistanceM: 140,
    ),
    2: BeepTestLevelData(
      level: 2,
      shuttles: 8,
      speedKmh: 9.0,
      timePerShuttleSec: 8.00,
      cumulativeTimeSec: 127.0,
      cumulativeDistanceM: 300,
    ),
    3: BeepTestLevelData(
      level: 3,
      shuttles: 8,
      speedKmh: 9.5,
      timePerShuttleSec: 7.58,
      cumulativeTimeSec: 187.6,
      cumulativeDistanceM: 460,
    ),
    4: BeepTestLevelData(
      level: 4,
      shuttles: 9,
      speedKmh: 10.0,
      timePerShuttleSec: 7.20,
      cumulativeTimeSec: 252.4,
      cumulativeDistanceM: 640,
    ),
    5: BeepTestLevelData(
      level: 5,
      shuttles: 9,
      speedKmh: 10.5,
      timePerShuttleSec: 6.86,
      cumulativeTimeSec: 314.1,
      cumulativeDistanceM: 820,
    ),
    6: BeepTestLevelData(
      level: 6,
      shuttles: 10,
      speedKmh: 11.0,
      timePerShuttleSec: 6.55,
      cumulativeTimeSec: 379.6,
      cumulativeDistanceM: 1020,
    ),
    7: BeepTestLevelData(
      level: 7,
      shuttles: 10,
      speedKmh: 11.5,
      timePerShuttleSec: 6.26,
      cumulativeTimeSec: 442.2,
      cumulativeDistanceM: 1220,
    ),
    8: BeepTestLevelData(
      level: 8,
      shuttles: 11,
      speedKmh: 12.0,
      timePerShuttleSec: 6.00,
      cumulativeTimeSec: 508.2,
      cumulativeDistanceM: 1440,
    ),
    9: BeepTestLevelData(
      level: 9,
      shuttles: 11,
      speedKmh: 12.5,
      timePerShuttleSec: 5.76,
      cumulativeTimeSec: 571.6,
      cumulativeDistanceM: 1660,
    ),
    10: BeepTestLevelData(
      level: 10,
      shuttles: 11,
      speedKmh: 13.0,
      timePerShuttleSec: 5.54,
      cumulativeTimeSec: 632.5,
      cumulativeDistanceM: 1880,
    ),
    11: BeepTestLevelData(
      level: 11,
      shuttles: 12,
      speedKmh: 13.5,
      timePerShuttleSec: 5.33,
      cumulativeTimeSec: 696.5,
      cumulativeDistanceM: 2120,
    ),
    12: BeepTestLevelData(
      level: 12,
      shuttles: 12,
      speedKmh: 14.0,
      timePerShuttleSec: 5.14,
      cumulativeTimeSec: 758.2,
      cumulativeDistanceM: 2360,
    ),
    13: BeepTestLevelData(
      level: 13,
      shuttles: 13,
      speedKmh: 14.5,
      timePerShuttleSec: 4.97,
      cumulativeTimeSec: 822.8,
      cumulativeDistanceM: 2620,
    ),
    14: BeepTestLevelData(
      level: 14,
      shuttles: 13,
      speedKmh: 15.0,
      timePerShuttleSec: 4.80,
      cumulativeTimeSec: 885.2,
      cumulativeDistanceM: 2880,
    ),
    15: BeepTestLevelData(
      level: 15,
      shuttles: 13,
      speedKmh: 15.5,
      timePerShuttleSec: 4.65,
      cumulativeTimeSec: 945.6,
      cumulativeDistanceM: 3140,
    ),
    16: BeepTestLevelData(
      level: 16,
      shuttles: 14,
      speedKmh: 16.0,
      timePerShuttleSec: 4.50,
      cumulativeTimeSec: 1008.6,
      cumulativeDistanceM: 3420,
    ),
    17: BeepTestLevelData(
      level: 17,
      shuttles: 14,
      speedKmh: 16.5,
      timePerShuttleSec: 4.36,
      cumulativeTimeSec: 1069.7,
      cumulativeDistanceM: 3700,
    ),
    18: BeepTestLevelData(
      level: 18,
      shuttles: 15,
      speedKmh: 17.0,
      timePerShuttleSec: 4.24,
      cumulativeTimeSec: 1133.2,
      cumulativeDistanceM: 4000,
    ),
    19: BeepTestLevelData(
      level: 19,
      shuttles: 15,
      speedKmh: 17.5,
      timePerShuttleSec: 4.11,
      cumulativeTimeSec: 1194.9,
      cumulativeDistanceM: 4300,
    ),
    20: BeepTestLevelData(
      level: 20,
      shuttles: 16,
      speedKmh: 18.0,
      timePerShuttleSec: 4.00,
      cumulativeTimeSec: 1258.9,
      cumulativeDistanceM: 4620,
    ),
    21: BeepTestLevelData(
      level: 21,
      shuttles: 16,
      speedKmh: 18.5,
      timePerShuttleSec: 3.89,
      cumulativeTimeSec: 1321.2,
      cumulativeDistanceM: 4940,
    ),
  };

  static List<int> get allLevels => levels.keys.toList()..sort();

  static List<int> shuttlesForLevel(int? level) {
    final data = level == null ? null : levels[level];
    if (data == null) return const [];
    return List.generate(data.shuttles, (index) => index + 1);
  }

  static BeepTestResultData? calculate({
    required int? level,
    required int? shuttle,
    int? age,
  }) {
    if (level == null || shuttle == null) return null;

    final current = levels[level];
    if (current == null) return null;
    if (shuttle < 1 || shuttle > current.shuttles) return null;

    final previousCumulativeTime = level == 1
        ? 0.0
        : (levels[level - 1]?.cumulativeTimeSec ?? 0.0);

    final previousCumulativeDistance = level == 1
        ? 0
        : (levels[level - 1]?.cumulativeDistanceM ?? 0);

    final totalTimeSec =
        previousCumulativeTime + (shuttle * current.timePerShuttleSec);

    final totalDistanceM = previousCumulativeDistance + (shuttle * 20);

    final continuousScore = level + (shuttle / current.shuttles);

    final effectiveAge = age ?? 18;
    final x = current.speedKmh;
    final vo2max =
        31.025 +
        (3.238 * x) -
        (3.248 * effectiveAge) +
        (0.1536 * effectiveAge * x);

    return BeepTestResultData(
      level: level,
      shuttle: shuttle,
      speedKmh: current.speedKmh,
      totalTimeSec: totalTimeSec,
      totalDistanceM: totalDistanceM,
      continuousScore: continuousScore,
      vo2maxMlKgMin: vo2max,
    );
  }

  static String formatTime(double seconds) {
    final total = seconds.round();
    final min = total ~/ 60;
    final sec = total % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
