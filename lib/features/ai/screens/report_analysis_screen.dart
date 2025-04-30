import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportAnalysisScreen extends StatefulWidget {
  final String reportUrl;
  const ReportAnalysisScreen({Key? key, required this.reportUrl}) : super(key: key);

  @override
  State<ReportAnalysisScreen> createState() => _ReportAnalysisScreenState();
}

class _ReportAnalysisScreenState extends State<ReportAnalysisScreen> {
  bool _loading = false;
  String? _result;
  String? _error;

  Future<void> _analyzeReport() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // TODO: Replace with your actual Colab endpoint URL
      final url = Uri.parse('https://your-colab-endpoint/analyze_report');
      final response = await http.post(url, body: jsonEncode({'reportUrl': widget.reportUrl}), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        setState(() {
          _result = response.body;
        });
      } else {
        setState(() {
          _error = 'Failed to analyze report.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Analysis (AI)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _analyzeReport,
              child: const Text('Analyze Report'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null)
              Expanded(
                child: SingleChildScrollView(child: Text(_result!)),
              ),
          ],
        ),
      ),
    );
  }
}
