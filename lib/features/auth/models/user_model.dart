import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String code;
  final String role;
  final String email;
  final String province;
  final String? profilePictureUrl;
  final DateTime lastActivity;

  AppUser({
    required this.uid,
    required this.code,
    required this.role,
    required this.email,
    required this.province,
    this.profilePictureUrl,
    required this.lastActivity,
  });

  // Add fromMap/toMap for Firestore integration
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      code: map['code'],
      role: map['role'],
      email: map['email'],
      province: map['province'],
      profilePictureUrl: map['profilePictureUrl'],
      lastActivity: (map['lastActivity'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'code': code,
      'role': role,
      'email': email,
      'province': province,
      'profilePictureUrl': profilePictureUrl,
      'lastActivity': lastActivity,
    };
  }
}
