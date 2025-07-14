// lib/screens/add_category_screen.dart
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  String? _selectedCategoryType; // To hold selected category type (Quotes/Health)

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Name input field
            TextFormField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                labelText: 'Category Name:',
                hintText: 'Enter category name',
              ),
            ),
            const SizedBox(height: 24),
            // Category Type Dropdown
            const Text(
              'Category Type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategoryType,
              hint: const Text('Select Type'),
              decoration: const InputDecoration(
                // Apply input decoration theme from main.dart
              ),
              items: <String>['Quotes', 'Health'] // Options as per assignment
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoryType = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            // Choose Image for Category button
            const Text(
              'Choose image for category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement actual image picking logic here (e.g., using image_picker package)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image picking functionality not implemented yet.')),
                );
              },
              icon: const Icon(Icons.image),
              label: const Text('Tap to choose image'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey[700], // Different color for this button
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            // Save button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement save logic (e.g., save to Firestore/database)
                String categoryName = _categoryNameController.text.trim();
                String categoryType = _selectedCategoryType ?? 'N/A';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Category "$categoryName" (Type: $categoryType) saved! (Placeholder)') // Placeholder message
                  ),
                );
                Navigator.of(context).pop(); // Go back to dashboard
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
