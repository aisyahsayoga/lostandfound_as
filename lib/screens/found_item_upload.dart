import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../theme/color_palette.dart';
import '../components/form_fields.dart';
import '../components/buttons.dart';
import '../components/animations.dart';

class FoundItemUploadScreen extends StatefulWidget {
  const FoundItemUploadScreen({Key? key}) : super(key: key);

  @override
  State<FoundItemUploadScreen> createState() => _FoundItemUploadScreenState();
}

class _FoundItemUploadScreenState extends State<FoundItemUploadScreen> {
  int _currentStep = 0;

  String? locationFound;
  final TextEditingController descriptionController = TextEditingController();
  DateTime? timeFound;
  List<String> photoUrls = [];

  void _onNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      // TODO: Submit the found item data
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
      initialDate: timeFound ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(timeFound ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      timeFound = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Found', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
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
                child: Center(child: Text(locationFound ?? 'Select location on map')),
              ),
            ),
          ],
        );
      case 1:
        return TextInputField(
          label: 'Description',
          controller: descriptionController,
          hintText: 'Describe the found item',
          multiline: true,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time Found', style: appThemeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
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
                child: Text(timeFound != null ? timeFound.toString() : 'Select time found'),
              ),
            ),
          ],
        );
      case 3:
        // Confirmation screen with animation (placeholder)
        return Center(
          child: FadeIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline, size: 120, color: AppColors.accentPrimary),
                const SizedBox(height: 24),
                Text(
                  'Found Item Uploaded Successfully!',
                  style: appThemeData.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for helping reunite lost items with their owners.',
                style: appThemeData.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _currentStep == 3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Found Item'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isLastStep)
              Text(
                'Step ${_currentStep + 1} of 4',
                style: appThemeData.textTheme.bodyMedium,
              ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildStepContent(),
            ),
            if (!isLastStep)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    SecondaryButton(label: 'Back', onPressed: _onBack)
                  else
                    const SizedBox(width: 100),
                  PrimaryButton(label: 'Next', onPressed: _onNext),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
