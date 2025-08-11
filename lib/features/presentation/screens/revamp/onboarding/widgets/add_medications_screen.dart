import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';
import 'package:foxxhealth/features/data/services/onboarding_service.dart';

class AddMedicationsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  
  const AddMedicationsScreen({super.key, this.onNext, this.questions = const []});

  @override
  State<AddMedicationsScreen> createState() => _AddMedicationsScreenState();
}

class _AddMedicationsScreenState extends State<AddMedicationsScreen> {
  final List<TextEditingController> _medicationControllers = [TextEditingController()];
  final List<FocusNode> _focusNodes = [FocusNode()];

  @override
  void dispose() {
    for (var controller in _medicationControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _addMedicationField() {
    setState(() {
      _medicationControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    });
  }

  void _removeMedicationField(int index) {
    if (_medicationControllers.length > 1) {
      setState(() {
        _medicationControllers[index].dispose();
        _focusNodes[index].dispose();
        _medicationControllers.removeAt(index);
        _focusNodes.removeAt(index);
      });
    }
  }

  Widget _buildMedicationField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _medicationControllers[index],
                focusNode: _focusNodes[index],
                decoration: InputDecoration(
                  hintText: 'Add Item',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: AppTextStyles.bodyOpenSans,
              ),
            ),
            if (_medicationControllers.length > 1)
              IconButton(
                onPressed: () => _removeMedicationField(index),
                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add your medications or supplements',
                style: AppHeadingTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                'If you\'re not sure, still figuring it out, or would rather answer later, that\'s totally okay. You can update this anytime in your Health Profile.',
                style: AppOSTextStyles.osMd
                    .copyWith(color: AppColors.primary01),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(_medicationControllers.length, (index) => _buildMedicationField(index)),
                      InkWell(
                        onTap: _addMedicationField,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.amethystViolet,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Add Item',
                                style: AppTextStyles.bodyOpenSans.copyWith(
                                  color: AppColors.amethystViolet,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FoxxNextButton(
                  isEnabled: true, // Always enabled since it's optional
                  onPressed: () {
                    // Close keyboard
                    FocusScope.of(context).unfocus();
                    widget.onNext?.call();
                  },
                  text: 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 