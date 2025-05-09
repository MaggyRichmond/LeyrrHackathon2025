import 'package:flutter/material.dart';
import 'package:leyrr/HomeScreen.dart';
import 'package:leyrr/PlanScreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'LocalUser.dart';
import 'WelcomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedLanguage;
  String? _selectedCountry;
  bool _receiveEmails = false;

  final List<String> languages = [
    'French (France)', 'French (Canada)', 'French (Belgium)', 'French (Switzerland)',
    'French (Luxembourg)', 'French (Senegal)',
    'French (Ivory Coast)', 'French (Cameroon)', 'French (Tunisia)',
    'French (Morocco)', 'French (Algeria)', 'French (Madagascar)',
    'French (Haiti)', 'French (DR of the Congo)',
  ];

  final List<String> countries = [
    'France', 'Canada', 'Belgium', 'Switzerland', 'Luxembourg',
    'Senegal', 'Ivory Coast', 'Cameroon', 'Tunisia', 'Morocco',
    'Algeria', 'Madagascar', 'Haiti', 'DR of the Congo',
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = LocalUser(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text,
        language: _selectedLanguage ?? '',
        country: _selectedCountry ?? '',
        receiveEmails: _receiveEmails,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen())),
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 10,
            margin: const EdgeInsets.only(top: 24, bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildTextField(
                      controller: _firstNameController,
                      label: "First Name",
                      icon: Icons.person_outline,
                    ),
                    _buildTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Language",
                      value: _selectedLanguage,
                      items: languages,
                      onChanged: (value) => setState(() => _selectedLanguage = value),
                    ),
                    _buildDropdownField(
                      label: "Country",
                      value: _selectedCountry,
                      items: countries,
                      onChanged: (value) => setState(() => _selectedCountry = value),
                    ),

                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: _receiveEmails,
                      onChanged: (val) => setState(() => _receiveEmails = val ?? false),
                      title: const Text("I wish to receive news by email"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        label: const Text("Create Account", style: TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.deepPurpleAccent
                        ),
                        onPressed: _submitForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) =>
        value == null || value.isEmpty ? 'This field is required' : null,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
        value == null ? 'Please select an option' : null,
      ),
    );
  }
}
