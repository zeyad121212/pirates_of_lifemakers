import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trainings per Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('training_requests').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data.'));
                  }
                  final docs = snapshot.data!.docs;
                  final Map<String, int> monthCounts = {};
                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final dateStr = data['date'] as String?;
                    if (dateStr != null) {
                      final month = dateStr.substring(0, 7); // YYYY-MM
                      monthCounts[month] = (monthCounts[month] ?? 0) + 1;
                    }
                  }
                  final months = monthCounts.keys.toList()..sort();
                  return ListView.builder(
                    itemCount: months.length,
                    itemBuilder: (context, i) {
                      final month = months[i];
                      return ListTile(
                        title: Text(month),
                        trailing: Text(monthCounts[month].toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
