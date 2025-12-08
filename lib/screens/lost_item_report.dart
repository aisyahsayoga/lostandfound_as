import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../components/form_fields.dart';
import '../components/buttons.dart';

class LostItemReportScreen extends StatefulWidget {
  const LostItemReportScreen({Key? key}) : super(key: key);

  @override
  State<LostItemReportScreen> createState() => _LostItemReportScreenState();
}

class _LostItemReportScreenState extends State<LostItemReportScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? selectedCategory;
  DateTime? reportDate;
  bool isFound = false; // false = Lost, true = Found
  List<String> photoUrls = [];
  final List<XFile> _selectedImages = [];

  final List<String> categories = [
    'Electronics',
    'Personal Items',
    'Documents',
    'Apparel',
  ];

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: reportDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    setState(() {
      reportDate = DateTime(date.year, date.month, date.day);
    });
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Select date';
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file != null) {
      setState(() {
        _selectedImages.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost or Found Item'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Lost'),
                  selected: !isFound,
                  onSelected: (_) => setState(() => isFound = false),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Found'),
                  selected: isFound,
                  onSelected: (_) => setState(() => isFound = true),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextInputField(
              label: 'Item Name',
              controller: itemNameController,
              hintText: isFound
                  ? 'Name of the found item'
                  : 'Name of the lost item',
            ),
            const SizedBox(height: 16),
            TextInputField(
              label: 'Description',
              controller: descriptionController,
              hintText: 'Describe the item',
              multiline: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Category/Type',
              style: appThemeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.neutralLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: Text(
                'Select category/type',
                style: appThemeData.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralMedium,
                ),
              ),
              initialValue: selectedCategory,
              items: categories
                  .map(
                    (cat) =>
                        DropdownMenuItem<String>(value: cat, child: Text(cat)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 16),
            Text(
              isFound ? 'Date Found' : 'Date of Loss',
              style: appThemeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _formatDate(reportDate),
                  style: (reportDate == null)
                      ? appThemeData.textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutralMedium,
                        )
                      : appThemeData.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextInputField(
              label: isFound ? 'Item Found at' : 'Last seen location',
              controller: locationController,
              hintText: isFound
                  ? 'e.g., Lab Computer Room'
                  : 'e.g., Theater or Sahabat',
            ),
            const SizedBox(height: 24),
            PhotoUploadField(
              label: 'Photos',
              onUploadPressed: () => _pickImage(ImageSource.camera),
              onUploadFromGalleryPressed: () => _pickImage(ImageSource.gallery),
              photoUrls: photoUrls,
              localImagePaths: _selectedImages.map((x) => x.path).toList(),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Submit',
              fullWidth: true,
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You must be logged in to submit a report'),
                    ),
                  );
                  return;
                }

                final name = itemNameController.text.trim();
                final desc = descriptionController.text.trim();
                final loc = locationController.text.trim();
                if (name.isEmpty ||
                    desc.isEmpty ||
                    selectedCategory == null ||
                    reportDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  final uploaded = <String>[];
                  for (var i = 0; i < _selectedImages.length; i++) {
                    final x = _selectedImages[i];
                    final ref = FirebaseStorage.instance.ref().child(
                      'item_photos/${user.uid}/${DateTime.now().toIso8601String()}_$i.jpg',
                    );
                    await ref.putFile(File(x.path));
                    final url = await ref.getDownloadURL();
                    uploaded.add(url);
                  }

                  final data = {
                    'itemName': name,
                    'description': desc,
                    'category': selectedCategory,
                    'location': loc,
                    'reportDate': reportDate,
                    'isFound': isFound,
                    'createdAt': FieldValue.serverTimestamp(),
                    'reporterId': user.uid,
                    'photoUrls': uploaded,
                  };
                  await FirebaseFirestore.instance
                      .collection('items')
                      .add(data);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to submit: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
