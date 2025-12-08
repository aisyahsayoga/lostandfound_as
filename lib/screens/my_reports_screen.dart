import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('items')
        .where('reporterId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Reports')),
        body: Center(
          child: Text(
            'Anda belum login',
            style: appThemeData.textTheme.bodyLarge,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reportsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: appThemeData.textTheme.bodyLarge),
            );
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text('Belum ada laporan', style: appThemeData.textTheme.bodyLarge),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final title = (data['itemName'] ?? 'Untitled').toString();
              final status = (data['isFound'] == true) ? 'Found' : 'Lost';
              final location = (data['location'] ?? '-').toString();
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text('$status • $location'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
