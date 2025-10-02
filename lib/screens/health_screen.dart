import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int selectedMood = -1;
  final List<String> moods = ["😢", "😟", "😐", "😊", "😁"];

  final Map<String, int> ratings = {
    "Hunger": 0,
    "Hydration": 0,
    "Sleep Quality": 0,
    "Energy Level": 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Mood"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Log Your Mood", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Mood", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(moods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedMood = index);
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: selectedMood == index ? Colors.blue[100] : Colors.grey[200],
                    child: Text(moods[index], style: const TextStyle(fontSize: 22)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ...ratings.keys.map((category) => _buildRatingRow(category)).toList(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              int value = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() => ratings[category] = value);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: ratings[category] == value ? Colors.blue[100] : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(value.toString()),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}