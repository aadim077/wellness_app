// lib/screens/add_health_tips_screen.dart
import 'package:flutter/material.dart';

class AddHealthTipsScreen extends StatefulWidget {
  const AddHealthTipsScreen({super.key});

  @override
  State<AddHealthTipsScreen> createState() => _AddHealthTipsScreenState();
}

class _AddHealthTipsScreenState extends State<AddHealthTipsScreen> {
  // Default to 'Health' as per assignment design, assuming it's the only option for this screen
  String? _selectedCategory = 'Health';
  final TextEditingController _healthTipsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _healthTipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Tips'),
      ),
      body: SingleChildScrollView( // Allows content to scroll if it overflows
        padding: const EdgeInsets.all(24.0), // Padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
          children: [
            // Label for the category dropdown
            const Text(
              'Select Category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 8), // Spacer
            // Dropdown for selecting category (fixed to 'Health' based on assignment)
            DropdownButtonFormField<String>(
              value: _selectedCategory, // Currently selected value
              hint: const Text('Health'), // Placeholder text
              decoration: const InputDecoration(
                // This will pick up the InputDecorationTheme defined in main.dart
              ),
              items: <String>['Health'] // Only 'Health' is an option for this screen
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Update the selected category when the dropdown value changes
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 24), // Spacer
            // Text field for Health Tips content
            TextFormField(
              controller: _healthTipsController, // Controller to get text input
              maxLines: 5, // Allows the text field to expand to 5 lines
              decoration: const InputDecoration(
                labelText: 'Health Tips:', // Label for the input field
                hintText: 'Write a health tips', // Hint text inside the field
              ),
            ),
            const SizedBox(height: 32), // Spacer
            // Save button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual save logic here.
                // For now, it just shows a SnackBar and navigates back.
                String healthTipText = _healthTipsController.text.trim();

                // Show a temporary success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Health Tip saved! (Placeholder)')
                  ),
                );
                // Navigate back to the previous screen (Dashboard)
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Makes the button full width
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
