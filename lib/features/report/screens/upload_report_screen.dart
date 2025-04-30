import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({Key? key}) : super(key: key);

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {
  PlatformFile? _reportFile;
  XFile? _signaturePhoto;
  bool _loading = false;
  double _rating = 0;

  Future<void> _pickReportFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'xlsx']);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _reportFile = result.files.first);
    }
  }

  Future<void> _pickSignaturePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _signaturePhoto = photo);
    }
  }

  Future<void> _uploadReport() async {
    if (_reportFile == null || _signaturePhoto == null || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields.')));
      return;
    }
    setState(() => _loading = true);
    try {
      // Upload report file
      final reportRef = FirebaseStorage.instance.ref().child('reports/${_reportFile!.name}');
      await reportRef.putData(_reportFile!.bytes!);
      final reportUrl = await reportRef.getDownloadURL();
      // Upload signature photo
      final sigRef = FirebaseStorage.instance.ref().child('signatures/${_signaturePhoto!.name}');
      await sigRef.putData(await _signaturePhoto!.readAsBytes());
      final sigUrl = await sigRef.getDownloadURL();
      // TODO: Save report metadata (including URLs and rating) to Firestore
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report uploaded!')));
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
      appBar: AppBar(title: const Text('Upload Training Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _pickReportFile,
              child: Text(_reportFile == null ? 'Pick Report File (PDF/Excel)' : _reportFile!.name),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickSignaturePhoto,
              child: Text(_signaturePhoto == null ? 'Capture Signature Photo' : 'Signature Photo Selected'),
            ),
            const SizedBox(height: 16),
            Text('Trainee Ratings:', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: List.generate(5, (i) => IconButton(
                icon: Icon(i < _rating ? Icons.star : Icons.star_border),
                color: Colors.amber,
                onPressed: () => setState(() => _rating = i + 1.0),
              )),
            ),
            const SizedBox(height: 24),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _uploadReport,
                    child: const Text('Upload Report'),
                  ),
          ],
        ),
      ),
    );
  }
}
