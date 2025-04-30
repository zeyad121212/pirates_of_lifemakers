import 'package:flutter/material.dart';
import '../report/screens/upload_report_screen.dart';

class TrDashboard extends StatelessWidget {
  const TrDashboard({Key? key, required String userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trainer Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UploadReportScreen()),
            );
          },
          child: const Text('Upload Training Report'),
        ),
      ),
    );
  }
}
