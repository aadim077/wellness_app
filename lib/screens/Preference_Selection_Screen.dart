// lib/screens/preference_selection_screen.dart (CORRECTED)
import 'package:flutter/material.dart';
import 'package:wellness/services/firestore_service.dart';
import 'package:wellness/screens/dashboard_screen.dart'; // Navigate here after saving preferences
// Import the data models
import 'package:wellness/models/preference.dart';
import 'package:wellness/models/user_preference.dart';

class PreferenceSelectionScreen extends StatefulWidget {
  const PreferenceSelectionScreen({super.key});

  @override
  State<PreferenceSelectionScreen> createState() => _PreferenceSelectionScreenState();
}

class _PreferenceSelectionScreenState extends State<PreferenceSelectionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Preference> _availablePreferences = []; // Corrected: Using Preference directly
  List<String> _selectedPreferenceIds = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    try {
      // Fetch all preferences from Firestore
      _firestoreService.getAllPreferencesStream().listen((preferences) {
        setState(() {
          _availablePreferences = preferences;
          _isLoading = false;
        });
      });

      // Also fetch existing user preferences if any
      UserPreference? userPrefs = await _firestoreService.getUserPreferencesOnce(); // Corrected: Using UserPreference directly
      if (userPrefs != null) {
        setState(() {
          _selectedPreferenceIds = userPrefs.preferenceIds;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load preferences: $e';
        _isLoading = false;
      });
      print(_errorMessage);
    }
  }

  void _togglePreference(String preferenceId) {
    setState(() {
      if (_selectedPreferenceIds.contains(preferenceId)) {
        _selectedPreferenceIds.remove(preferenceId);
      } else {
        _selectedPreferenceIds.add(preferenceId);
      }
    });
  }

  Future<void> _savePreferences() async {
    if (_selectedPreferenceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one preference.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Use a separate loading state for saving
    });

    try {
      await _firestoreService.saveUserPreferences(_selectedPreferenceIds);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully!')),
      );
      // Navigate to Dashboard after saving
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen(dashboardViewModel: null,)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save preferences: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Wellness Preferences'),
        automaticallyImplyLeading: false, // Hide back button for initial selection
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _availablePreferences.length,
              itemBuilder: (context, index) {
                final preference = _availablePreferences[index];
                final isSelected = _selectedPreferenceIds.contains(preference.id);
                return Card(
                  color: isSelected ? Colors.blueGrey[700] : Colors.grey[850],
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      preference.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                        : null,
                    onTap: () => _togglePreference(preference.id),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: _savePreferences,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }
}
