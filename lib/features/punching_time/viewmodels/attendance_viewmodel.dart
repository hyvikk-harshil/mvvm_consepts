import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../repositorys/iattendance_repository.dart';

class AttendanceViewModel extends ChangeNotifier {
  final IAttendanceRepository _repository;

  AttendanceViewModel(this._repository) {
    _loadData();
  }

  List<AttendanceRecordeModel> _records = [];
  bool _isLoading = true;

  // Getters
  bool get isLoading => _isLoading;
// Append this tracking array getter directly inside your `AttendanceViewModel` class structure:
  List<AttendanceRecordeModel> get allRecords => _records;

  // Basic Target: Assume a standard 30-day monitoring block
  int get totalDaysInMonth => 30;

  // Dashboard Analytical Metrics
  int get daysAttended => _records.where((r) => r.punchIn != null && !r.isWeekOff && !r.isHoliday).length;
  int get holidayCount => _records.where((r) => r.isHoliday).length;
  int get weekOffCount => _records.where((r) => r.isWeekOff).length;
  int get latePunchCount => _records.where((r) => r.isLatePunch).length;

  int get daysLeft {
    final remaining = totalDaysInMonth - (daysAttended + holidayCount + weekOffCount);
    return remaining < 0 ? 0 : remaining;
  }

  AttendanceRecordeModel get todayRecord {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    return _records.firstWhere(
          (r) => r.date == todayStr,
      orElse: () {
        final weekday = DateTime.now().weekday;
        // Saturday (6) and Sunday (7) default to Week Offs
        bool isWeekend = (weekday == DateTime.saturday || weekday == DateTime.sunday);
        return AttendanceRecordeModel(date: todayStr, isWeekOff: isWeekend);
      },
    );
  }

  // Repository data loading
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();
    _records = await _repository.fetchRecords();
    _isLoading = false;
    notifyListeners();
  }

  // Interactive Punch execution
  Future<void> executePunch() async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final index = _records.indexWhere((r) => r.date == todayStr);
    debugPrint("---->>$index");
    final currentToday = todayRecord;
    AttendanceRecordeModel updatedRecord;

    if (index == -1) {
      // Create new record for Punch In
      updatedRecord = AttendanceRecordeModel(
        date: todayStr,
        punchIn: DateTime.now(),
        isWeekOff: currentToday.isWeekOff,
      );
      _records.add(updatedRecord);
    } else {
      // Modify existing record for Punch Out
      final existing = _records[index];
      updatedRecord = AttendanceRecordeModel(
        date: todayStr,
        punchIn: existing.punchIn,
        punchOut: DateTime.now(),
        isWeekOff: existing.isWeekOff,
        isHoliday: existing.isHoliday,
      );
      _records[index] = updatedRecord;
    }

    notifyListeners();
    await _repository.saveRecords(_records);
  }
}