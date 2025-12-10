import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as Models;
import '../services/auth_service.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../components/buttons.dart';

class ItemDetailScreen extends StatefulWidget {
  final String documentId;
  const ItemDetailScreen({Key? key, required this.documentId})
    : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Future<Models.Document> _loadDoc() {
    return AuthService().getItem(widget.documentId);
  }

  String _fmtDate(dynamic value) {
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

  Future<void> _claimItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to claim this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await AuthService().markItemFound(widget.documentId);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Models.Document>(
      future: _loadDoc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Item Details')),
            body: Center(
              child: Text(
                'Unable to load item.',
                style: appThemeData.textTheme.bodyLarge,
              ),
            ),
          );
        }
        final data = snapshot.data!.data;
        final itemName = (data['title'] ?? 'Item').toString();
        final description = (data['description'] ?? '-').toString();
        final category = (data['category'] ?? '-').toString();
        final location = (data['location'] ?? '-').toString();
        final reportDate = _fmtDate(data['reportDate']);

        return Scaffold(
          appBar: AppBar(title: Text(itemName), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.neutralLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Description', style: appThemeData.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(description, style: appThemeData.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Text('Category', style: appThemeData.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(category, style: appThemeData.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Text('Location', style: appThemeData.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(location, style: appThemeData.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Text('Reported on', style: appThemeData.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(reportDate, style: appThemeData.textTheme.bodyLarge),
                const Spacer(),
                PrimaryButton(
                  label: 'I Have Found This Item',
                  onPressed: _claimItem,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
