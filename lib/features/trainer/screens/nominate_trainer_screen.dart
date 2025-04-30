// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NominateTrainerScreen extends StatelessWidget {
  final String requestId;
  const NominateTrainerScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Add filters for expertise, experience, proximity
    return Scaffold(
      appBar: AppBar(title: const Text('Nominate Trainer')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: Call AI recommendation endpoint
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Recommendation not yet implemented.')),
              );
            },
            child: const Text('Get AI Recommendation'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('trainers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No trainers found.'));
                }
                final trainers = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: trainers.length,
                  itemBuilder: (context, i) {
                    final data = trainers[i].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['name'] ?? ''),
                        subtitle: Text('Expertise: ${data['specialization'] ?? ''}\nExperience: ${data['experience'] ?? ''} yrs'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            // Nominate this trainer for the request
                            await FirebaseFirestore.instance.collection('training_requests').doc(requestId).update({
                              'nominatedTrainerId': trainers[i].id,
                              'nominatedAt': FieldValue.serverTimestamp(),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Trainer nominated!')),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Nominate'),
                        ),
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
