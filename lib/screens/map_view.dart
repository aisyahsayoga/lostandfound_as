import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String? selectedCategory;
  String? selectedTime;
  double selectedDistance = 10.0;

  final List<String> categories = [
    'All',
    'Electronics',
    'Personal Items',
    'Documents',
    'Pets',
  ];

  final List<String> times = [
    'All',
    'Last 24 hours',
    'Last 7 days',
    'Last 30 days',
  ];

  void _onCategoryChanged(String? val) {
    setState(() {
      selectedCategory = val;
    });
  }

  void _onTimeChanged(String? val) {
    setState(() {
      selectedTime = val;
    });
  }

  void _onDistanceChanged(double val) {
    setState(() {
      selectedDistance = val;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first;
    selectedTime = times.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
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
                    onChanged: _onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Time',
                      filled: true,
                      fillColor: AppColors.neutralLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedTime,
                    items: times.map((time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: _onTimeChanged,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Distance: ${selectedDistance.toStringAsFixed(0)} km'),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 100,
                    divisions: 20,
                    value: selectedDistance,
                    onChanged: _onDistanceChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Interactive Map with Pins here',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
