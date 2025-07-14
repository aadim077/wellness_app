// lib/screens/add_quote_screen.dart
import 'package:flutter/material.dart';

class AddQuoteScreen extends StatefulWidget {
  const AddQuoteScreen({super.key});

  @override
  State<AddQuoteScreen> createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  // Default to 'Quotes' as per assignment design, assuming it's the only option for this screen
  String? _selectedCategory = 'Quotes';
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _authorNameController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quote'),
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
            // Dropdown for selecting category (fixed to 'Quotes' based on assignment)
            DropdownButtonFormField<String>(
              value: _selectedCategory, // Currently selected value
              hint: const Text('Quotes'), // Placeholder text
              decoration: const InputDecoration(
                // This will pick up the InputDecorationTheme defined in main.dart
              ),
              items: <String>['Quotes'] // Only 'Quotes' is an option for this screen
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
            // Text field for Author Name
            TextFormField(
              controller: _authorNameController, // Controller to get text input
              decoration: const InputDecoration(
                labelText: 'Author Name:', // Label for the input field
                hintText: 'Enter author name', // Hint text inside the field
              ),
            ),
            const SizedBox(height: 24), // Spacer
            // Text field for the Quote itself
            TextFormField(
              controller: _quoteController, // Controller to get text input
              maxLines: 5, // Allows the text field to expand to 5 lines
              decoration: const InputDecoration(
                labelText: 'Quote:', // Label for the input field
                hintText: 'Write a quote', // Hint text inside the field
              ),
            ),
            const SizedBox(height: 32), // Spacer
            // Save button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual save logic here.
                // For now, it just shows a SnackBar and navigates back.
                String authorName = _authorNameController.text.trim();
                String quoteText = _quoteController.text.trim();

                // Show a temporary success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Quote by "$authorName" saved! (Placeholder)')
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
