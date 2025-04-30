// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApproveTrainerScreen extends StatelessWidget {
  const ApproveTrainerScreen({Key? key}) : super(key: key);

  Future<void> _updateTrainerStatus(String requestId, String status, String? comment, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('training_requests').doc(requestId).update({
        'pmStatus': status,
        if (comment != null && comment.isNotEmpty) 'pmComment': comment,
        'pmReviewedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trainer $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Nominated Trainers')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('training_requests')
            .where('status', isEqualTo: 'approved')
            .where('nominatedTrainerId', isGreaterThan: '')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No nominated trainers to review.'));
          }
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, i) {
              final req = requests[i];
              final data = req.data() as Map<String, dynamic>;
              final TextEditingController commentController = TextEditingController();
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${data['date'] ?? ''}'),
                      Text('Location: ${data['location'] ?? ''}'),
                      Text('Specialization: ${data['specialization'] ?? ''}'),
                      Text('Attendees: ${data['attendees'] ?? ''}'),
                      Text('Nominated Trainer ID: ${data['nominatedTrainerId'] ?? ''}'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Comment (optional)',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _updateTrainerStatus(req.id, 'pm_approved', commentController.text, context),
                            child: const Text('Approve'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _updateTrainerStatus(req.id, 'pm_request_alternative', commentController.text, context),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Request Alternative'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
