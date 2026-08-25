import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_model.dart';
import 'iattendance_repository.dart';

class LocalAttendanceRepository implements IAttendanceRepository {
  static const String _storageKey = 'office_attendance_records';

  @override
  Future<List<AttendanceRecordeModel>> fetchRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_storageKey);

    if (cachedData == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(cachedData);
      return decodedList.map((item) => AttendanceRecordeModel.fromMap(item)).toList();
    } catch (e) {
      // Return empty list if parsing fails due to corrupted data
      return [];
    }
  }

  @override
  Future<void> saveRecords(List<AttendanceRecordeModel> records) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      records.map((record) => record.toMap()).toList(),
    );

    await prefs.setString(_storageKey, encodedData);
  }
}