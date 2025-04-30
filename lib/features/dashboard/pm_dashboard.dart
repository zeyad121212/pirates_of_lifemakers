import 'package:flutter/material.dart';
import '../trainer/screens/approve_trainer_screen.dart';

class PmDashboard extends StatelessWidget {
  const PmDashboard({Key? key, required String userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Manager Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApproveTrainerScreen()),
            );
          },
          child: const Text('Approve Trainers'),
        ),
      ),
    );
  }
}
