import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:appwrite/models.dart' as Models;
import '../theme/theme_data.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  Future<List<Models.Document>> _reportsFuture(String uid) {
    return AuthService().listMyReports();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
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
      body: FutureBuilder<List<Models.Document>>(
        future: _reportsFuture(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: appThemeData.textTheme.bodyLarge),
            );
          }
          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text('Belum ada laporan', style: appThemeData.textTheme.bodyLarge),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data;
              final title = (data['title'] ?? 'Untitled').toString();
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
