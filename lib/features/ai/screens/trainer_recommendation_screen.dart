import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainerRecommendationScreen extends StatefulWidget {
  final String requestId;
  const TrainerRecommendationScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  State<TrainerRecommendationScreen> createState() => _TrainerRecommendationScreenState();
}

class _TrainerRecommendationScreenState extends State<TrainerRecommendationScreen> {
  bool _loading = false;
  List<dynamic> _recommendations = [];
  String? _error;

  Future<void> _getRecommendations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // TODO: Replace with your actual Colab endpoint URL
      final url = Uri.parse('https://your-colab-endpoint/recommend');
      final response = await http.post(url, body: jsonEncode({'requestId': widget.requestId}), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        setState(() {
          _recommendations = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _error = 'Failed to get recommendations.';
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
      appBar: AppBar(title: const Text('Trainer Recommendations (AI)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getRecommendations,
              child: const Text('Get Recommendations'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_recommendations.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recommendations.length,
                  itemBuilder: (context, i) {
                    final rec = _recommendations[i];
                    return ListTile(
                      title: Text(rec['name'] ?? ''),
                      subtitle: Text('Score: ${rec['score'] ?? ''}'),
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
