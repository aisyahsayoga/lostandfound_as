import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:appwrite/models.dart' as Models;
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import 'lost_item_report.dart';
import 'item_detail_screen.dart';
import 'login.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  String _formatDate(dynamic value) {
    if (value == null) return '-';
    DateTime? dt;
    if (value is DateTime) {
      dt = value;
    } else if (value is String) {
      try {
        dt = DateTime.parse(value);
      } catch (_) {
        dt = null;
      }
    }
    if (dt == null) return '-';
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Items'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddButtonPressed,
          ),
        ],
      ),
      body: FutureBuilder<List<Models.Document>>(
        future: AuthService().listRecentItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred',
                style: appThemeData.textTheme.bodyLarge,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No lost items reported yet.',
                style: appThemeData.textTheme.bodyLarge,
              ),
            );
          }

          final docs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data;
              final itemName = (data['title'] ?? 'Unknown Item').toString();
              final location = (data['location'] ?? '-').toString();
              final reportDate = _formatDate(data['reportDate']);

              return Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shadowColor: AppColors.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ItemDetailScreen(documentId: docs[index].$id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: SizedBox(
                        width: 80,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.neutralLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        itemName,
                        style: appThemeData.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last seen at: $location',
                            style: appThemeData.textTheme.bodyMedium,
                          ),
                          Text(
                            'Reported on: $reportDate',
                            style: appThemeData.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onAddButtonPressed() async {
    final user = AuthService().currentUser;
    if (user == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
    if (AuthService().currentUser != null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LostItemReportScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk membuat laporan.')),
      );
    }
  }
}
