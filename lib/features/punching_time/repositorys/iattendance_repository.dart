import '../models/attendance_model.dart';

abstract class IAttendanceRepository {
  /// Fetches all stored attendance records from the database or local storage.
  Future<List<AttendanceRecordeModel>> fetchRecords();

  /// Saves the updated list of attendance records back to the storage layer.
  Future<void> saveRecords(List<AttendanceRecordeModel> records);
}