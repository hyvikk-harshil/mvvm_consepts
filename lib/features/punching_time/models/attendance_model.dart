class AttendanceRecordeModel {
  final String date; // Format: YYYY-MM-DD
  final DateTime? punchIn;
  final DateTime? punchOut;
  final bool isHoliday;
  final bool isWeekOff;

  AttendanceRecordeModel({
    required this.date,
    this.punchIn,
    this.punchOut,
    this.isHoliday = false,
    this.isWeekOff = false,
  });

  // Business Rules: Shift starts at 09:00 AM
  bool get isLatePunch {
    if (punchIn == null) return false;
    final shiftStart = DateTime(punchIn!.year, punchIn!.month, punchIn!.day, 9, 0);
    return punchIn!.isAfter(shiftStart);
  }

  // Business Rules: Calculate net time, subtracting 1 hour for lunch break
  double get netWorkHours {
    if (punchIn == null || punchOut == null) return 0.0;

    final totalDuration = punchOut!.difference(punchIn!);
    final rawHours = totalDuration.inMinutes / 60.0;

    // Deduct 1 hour lunch break only if the shift was longer than 4 hours
    if (rawHours > 4.0) {
      return (rawHours - 1.0) < 0 ? 0.0 : (rawHours - 1.0);
    }
    return rawHours;
  }

  // Serialization configurations for local storage
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'punchIn': punchIn?.toIso8601String(),
      'punchOut': punchOut?.toIso8601String(),
      'isHoliday': isHoliday ? 1 : 0,
      'isWeekOff': isWeekOff ? 1 : 0,
    };
  }

  factory AttendanceRecordeModel.fromMap(Map<String, dynamic> map) {
    return AttendanceRecordeModel(
      date: map['date'],
      punchIn: map['punchIn'] != null ? DateTime.parse(map['punchIn']) : null,
      punchOut: map['punchOut'] != null ? DateTime.parse(map['punchOut']) : null,
      isHoliday: map['isHoliday'] == 1,
      isWeekOff: map['isWeekOff'] == 1,
    );
  }
}