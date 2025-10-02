import 'package:flutter/material.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medications = [
      {
        "name": "Sertralina",
        "quantity": "30 pastillas",
        "startDate": "2025-09-25",
        "endDate": "2025-10-25",
        "interval": "Cada 8 horas",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final med = medications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.medication),
              title: Text(med["name"]!),
              subtitle: Text(
                "Cantidad: ${med["quantity"]}\n"
                "Inicio: ${med["startDate"]}\n"
                "Fin: ${med["endDate"]}\n"
                "Intervalo: ${med["interval"]}",
              ),
            ),
          );
        },
      ),
    );
  }
}