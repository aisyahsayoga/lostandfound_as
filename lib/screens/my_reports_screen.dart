import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:appwrite/models.dart' as Models;
import '../theme/theme_data.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  late Future<List<Models.Document>> _future;

  @override
  void initState() {
    super.initState();
    _future = AuthService().listMyReports();
  }

  void _reload() {
    setState(() {
      _future = AuthService().listMyReports();
    });
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
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: appThemeData.textTheme.bodyLarge,
              ),
            );
          }
          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Belum ada laporan',
                style: appThemeData.textTheme.bodyLarge,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data;
              final title = (data['title'] ?? 'Untitled').toString();
              final status = (data['isFound'] == true) ? 'Found' : 'Lost';
              final location = (data['location'] ?? '-').toString();
              final isResolved = data['isResolved'] == true;
              String? thumbUrl;
              final imgs = data['imageIds'];
              if (imgs is List && imgs.isNotEmpty && imgs.first is String) {
                thumbUrl = AuthService().fileViewUrl(imgs.first as String);
              }
              final cardColor = isResolved
                  ? Colors.green.withValues(alpha: 0.12)
                  : Theme.of(context).colorScheme.surface;
              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(title)),
                      if (isResolved)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Resolved',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text('$status • $location'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Mark as Resolved',
                        onPressed: isResolved
                            ? null
                            : () async {
                                try {
                                  await AuthService().markItemResolved(doc.$id);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Item marked as resolved'),
                                    ),
                                  );
                                  _reload();
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Gagal menandai resolved: $e',
                                      ),
                                    ),
                                  );
                                }
                              },
                        icon: Icon(
                          isResolved
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: isResolved ? Colors.green : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (thumbUrl != null)
                              ? Image.network(thumbUrl, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.photo,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
