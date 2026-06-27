import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../shared/data/dummy_data.dart';

/// Company business profile editor.
class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = DummyData.businessProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.padding),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/logo.png', height: 80),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Symbols.camera_alt, size: 16, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(labelText: 'Business Name'),
              controller: TextEditingController(text: profile.name),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: profile.email),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone'),
              controller: TextEditingController(text: profile.phone),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Address'),
              controller: TextEditingController(text: profile.address),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'GSTIN'),
              controller: TextEditingController(text: profile.gstin),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'PAN'),
              controller: TextEditingController(text: profile.pan),
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Save Profile',
              icon: Symbols.save,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
