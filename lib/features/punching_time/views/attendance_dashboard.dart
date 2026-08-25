import 'package:flutter/material.dart';
import 'package:mvvm_consepts/const/global_widgets/custom_gradient_appbar.dart';
import 'package:mvvm_consepts/const/global_widgets/drawer/navigation_drawer.dart';
import 'package:mvvm_consepts/features/punching_time/viewmodels/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceDashboard extends StatelessWidget {
  const AttendanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AttendanceViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final today = vm.todayRecord;
    final isPunchedIn = today.punchIn != null && today.punchOut == null;
    return Scaffold(
      appBar: CustomGradientAppBar(title: "Office Time"),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Live Operational Control Card
            Card(
              color: today.isWeekOff ? Colors.blue.shade50 : (isPunchedIn ? Colors.green.shade50 : Colors.orange.shade50),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      today.isWeekOff ? "WEEK OFF DAY" : (isPunchedIn ? "WORKING ON-SITE" : "OFFLINE/SIGNED OUT"),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('Punch In: ${today.punchIn?.toString().substring(11, 16) ?? "--:--"}'),
                    Text('Punch Out: ${today.punchOut?.toString().substring(11, 16) ?? "--:--"}'),
                    const Divider(height: 24),
                    Text(
                      'Net Hours (Excl. Lunch): ${today.netWorkHours.toStringAsFixed(2)} hrs',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: today.isWeekOff && today.punchIn == null
                          ? null // Prevent punching on week offs unless required
                          : () => context.read<AttendanceViewModel>().executePunch(),
                      icon: Icon(isPunchedIn ? Icons.logout : Icons.login),
                      label: Text(isPunchedIn ? 'Punch Out' : 'Punch In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPunchedIn ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Analytical Grid Summary Elements
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatTile('Days Attended', '${vm.daysAttended} Days', Colors.green),
                _buildStatTile('Days Left', '${vm.daysLeft} Days', Colors.blue),
                _buildStatTile('Holidays Tracked', '${vm.holidayCount} Days', Colors.purple),
                _buildStatTile('Late Arrivals', '${vm.latePunchCount} Times', Colors.red),
                _buildStatTile('Week Off Total', '${vm.weekOffCount} Days', Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}