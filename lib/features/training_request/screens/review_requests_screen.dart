// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRequestsScreen extends StatelessWidget {
  const ReviewRequestsScreen({Key? key}) : super(key: key);

  Future<void> _updateStatus(String docId, String status, String? comment, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('training_requests').doc(docId).update({
        'status': status,
        if (comment != null && comment.isNotEmpty) 'ccComment': comment,
        'ccReviewedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request $status')),
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
      appBar: AppBar(title: const Text('Review Training Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('training_requests')
            .where('status', isEqualTo: 'pending')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending requests.'));
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
                            onPressed: () => _updateStatus(req.id, 'approved', commentController.text, context),
                            child: const Text('Approve'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _updateStatus(req.id, 'rejected', commentController.text, context),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Reject'),
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
