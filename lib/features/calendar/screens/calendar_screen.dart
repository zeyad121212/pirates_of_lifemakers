import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatelessWidget {
  final String role;
  final String province; // For DV/CC filtering
  final String userId;   // For TR personal schedule
  const CalendarScreen({Key? key, required this.role, required this.province, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter logic based on role
    Query trainingsQuery = FirebaseFirestore.instance.collection('training_requests');
    if (role == 'DV') {
      trainingsQuery = trainingsQuery.where('province', isEqualTo: province);
    } else if (role == 'CC') {
      // Optionally allow province filter via UI
    } else if (role == 'TR') {
      trainingsQuery = trainingsQuery.where('trainerId', isEqualTo: userId);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Google Calendar sync (open URL or call backend)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Calendar sync not yet implemented.')),
              );
            },
            child: const Text('Sync with Google Calendar'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: trainingsQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No trainings scheduled.'));
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['date'] ?? ''),
                      subtitle: Text('${data['location'] ?? ''} - ${data['specialization'] ?? ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          // TODO: Set 24-hour reminder (local notification)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder set! (Demo only)')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
