import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wellness/dashboard_screen.dart';

class UserPreferenceScreen extends StatefulWidget {
  const UserPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<UserPreferenceScreen> createState() => _UserPreferenceScreenState();
}

class _UserPreferenceScreenState extends State<UserPreferenceScreen> {
  final List<String> _topics = [
    'Hard times', 'Working out', 'Productivity', 'Self-esteem',
    'Achieving goals', 'Inspiration', 'Letting go', 'Love',
    'Relationships', 'Faith & Spirituality', 'Positive thinking', 'Stress & Anxiety'
  ];
  final List<String> _selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Ensure app bar background is black
        elevation: 0, // No shadow for app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Select all topics that\nmotivates you',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28.sp,
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 3.5,
                ),
                itemCount: _topics.length,
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  final isSelected = _selectedTopics.contains(topic);
                  return ChoiceChip(
                    label: Text(
                      topic,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTopics.add(topic);
                        } else {
                          _selectedTopics.remove(topic);
                        }
                      });
                    },
                    selectedColor: Colors.white, // White when selected
                    backgroundColor: Theme.of(context).colorScheme.secondary, // Dark background when not selected
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide.none,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save selected preferences
                  print('Selected topics: $_selectedTopics');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                        (Route<dynamic> route) => false, // Remove all routes below
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text('Save'),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
