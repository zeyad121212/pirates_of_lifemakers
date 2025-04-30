import 'package:flutter/material.dart';
import '../calendar/screens/calendar_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../chat/screens/chat_selector_screen.dart';
import '../training_request/screens/review_requests_screen.dart';

class CcDashboard extends StatelessWidget {
  final String userId;
  final String province;
  const CcDashboard({Key? key, required this.userId, required this.province}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CC Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Life Makers')),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarScreen(role: 'CC', province: province, userId: userId)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatSelectorScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.assignment),
          label: const Text('Review Training Requests'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReviewRequestsScreen()),
            );
          },
        ),
      ),
    );
  }
}
