import 'package:flutter/material.dart';
import '../components/buttons.dart';
import '../components/form_fields.dart';
import '../components/animations.dart';
import '../theme/color_palette.dart';
import '../theme/theme_data.dart';

class LostItemReportScreen extends StatefulWidget {
  const LostItemReportScreen({Key? key}) : super(key: key);

  @override
  State<LostItemReportScreen> createState() => _LostItemReportScreenState();
}

class _LostItemReportScreenState extends State<LostItemReportScreen> {
  int _currentStep = 0;

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  DateTime? timeOfLoss;
  // For location and photos, placeholders for now
  String? lastSeenLocation;
  List<String> photoUrls = [];

  final List<String> categories = [
    'Electronics',
    'Personal Items',
    'Documents',
    'Pets',
  ];

  void _onNext() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      // TODO: Submit form data
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: timeOfLoss ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(timeOfLoss ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      timeOfLoss = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return TextInputField(
          label: 'Item Name',
          controller: itemNameController,
          hintText: 'Name of the lost item',
        );
      case 1:
        return TextInputField(
          label: 'Description',
          controller: descriptionController,
          hintText: 'Describe the item',
          multiline: true,
        );
      case 2:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Category/Type',
            filled: true,
            fillColor: AppColors.neutralLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          value: selectedCategory,
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat,
              child: Text(cat),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedCategory = val),
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Seen Location', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: Implement map location picker
              },
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutralMedium),
                ),
                child: Center(child: Text(lastSeenLocation ?? 'Select location on map')),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time of Loss', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDateTime,
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutralMedium),
                ),
                alignment: Alignment.centerLeft,
                child: Text(timeOfLoss != null ? timeOfLoss.toString() : 'Select time of loss'),
              ),
            ),
            const SizedBox(height: 24),
            PhotoUploadField(
              label: 'Photos',
              onUploadPressed: () {
                // TODO: Implement photo upload
              },
              photoUrls: photoUrls,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _currentStep == 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Item'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step ${_currentStep + 1} of 5',
              style: appThemeData.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FadeIn(
                child: _buildStepContent(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  SecondaryButton(
                    label: 'Back',
                    onPressed: _onBack,
                  )
                else
                  const SizedBox(width: 100),
                PrimaryButton(
                  label: isLastStep ? 'Submit' : 'Next',
                  onPressed: _onNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
