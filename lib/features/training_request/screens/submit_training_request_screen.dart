import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// TODO: Add Google Maps picker integration

class SubmitTrainingRequestScreen extends StatefulWidget {
  const SubmitTrainingRequestScreen({Key? key}) : super(key: key);

  @override
  State<SubmitTrainingRequestScreen> createState() => _SubmitTrainingRequestScreenState();
}

class _SubmitTrainingRequestScreenState extends State<SubmitTrainingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _attendeesController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    _specializationController.dispose();
    _attendeesController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('training_requests').add({
        'date': _dateController.text,
        'location': _locationController.text,
        'specialization': _specializationController.text,
        'attendees': _attendeesController.text,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Training Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (v) => v == null || v.isEmpty ? 'Enter date' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text = picked.toIso8601String().split('T').first;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location (tap to pick)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter location' : null,
                onTap: () {
                  // TODO: Open Google Maps picker
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
                validator: (v) => v == null || v.isEmpty ? 'Enter specialization' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _attendeesController,
                decoration: const InputDecoration(labelText: 'Attendees'),
                validator: (v) => v == null || v.isEmpty ? 'Enter attendees' : null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitRequest,
                      child: const Text('Submit Request'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
