// lib/screens/add_health_tips_screen.dart (FIXED)
import 'package:flutter/material.dart';
import 'package:wellness/services/firestore_service.dart'; // Correct import path/case
import 'package:wellness/models/preference.dart'; // Import the Preference model
import 'package:wellness/models/tip.dart'; // Import the Tip model (if needed for type hints, though not directly used in this screen's UI)


class AddHealthTipsScreen extends StatefulWidget {
  const AddHealthTipsScreen({super.key});

  @override
  State<AddHealthTipsScreen> createState() => _AddHealthTipsScreenState();
}

class _AddHealthTipsScreenState extends State<AddHealthTipsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _healthTipsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  bool _isSaving = false;
  List<Preference> _preferences = []; // Now directly using 'Preference'
  String? _selectedPreferenceId;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    try {
      _firestoreService.getAllPreferencesStream().listen((preferences) {
        setState(() {
          _preferences = preferences;
          _isLoading = false;
          if (_selectedPreferenceId == null && preferences.isNotEmpty) {
            _selectedPreferenceId = preferences.first.id;
          }
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load preferences: $e')),
        );
      });
    }
  }

  Future<void> _saveHealthTip() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPreferenceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a preference.')),
        );
        return;
      }
      setState(() {
        _isSaving = true;
      });
      try {
        await _firestoreService.addTip(
          _selectedPreferenceId!,
          _titleController.text.trim(),
          _healthTipsController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Health Tip added successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add health tip: $e')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _healthTipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Tips'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Preference:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPreferenceId,
                hint: const Text('Select Preference'),
                decoration: const InputDecoration(),
                items: _preferences.map((preference) {
                  return DropdownMenuItem<String>(
                    value: preference.id,
                    child: Text(preference.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPreferenceId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a preference';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tip Title:',
                  hintText: 'Enter a short title for the tip',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for the tip';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _healthTipsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Health Tips:',
                  hintText: 'Write a health tips',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the health tip details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveHealthTip,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
