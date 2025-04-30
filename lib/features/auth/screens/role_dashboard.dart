import 'package:flutter/material.dart';
import '../../dashboard/dv_dashboard.dart';
import '../../dashboard/cc_dashboard.dart';
import '../../dashboard/pm_dashboard.dart';
import '../../dashboard/sv_dashboard.dart';
import '../../dashboard/tr_dashboard.dart';
import '../../dashboard/mb_dashboard.dart';

class RoleDashboard extends StatelessWidget {
  final String role;
  const RoleDashboard({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'DV':
        return const DvDashboard(province: '', userId: '');
      case 'CC':
        return const CcDashboard(province: '', userId: '');
      case 'PM':
        return const PmDashboard(userId: '');
      case 'SV':
        return const SvDashboard(userId: '');
      case 'TR':
        return const TrDashboard(userId: '');
      case 'MB':
        return const MbDashboard(userId: '');
      default:
        return Scaffold(
          appBar: AppBar(title: const Text('Unknown Role')),
          body: Center(child: Text('Unknown role: $role', style: const TextStyle(fontSize: 24))),
        );
    }
  }
}
