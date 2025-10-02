import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {"date": "2025-09-30", "time": "10:00 AM", "description": "Consulta mensual"},
      {"date": "2025-10-10", "time": "02:00 PM", "description": "Seguimiento tratamiento"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appt = appointments[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text("${appt['date']} - ${appt['time']}"),
              subtitle: Text(appt['description']!),
            ),
          );
        },
      ),
    );
  }
}