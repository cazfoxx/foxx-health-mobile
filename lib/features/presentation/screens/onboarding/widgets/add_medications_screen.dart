import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';

class AddMedicationsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(List<String>)? onDataUpdate;

  /// ✅ Optional: populate previously entered medications
  final List<String>? currentValue;

  const AddMedicationsScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<AddMedicationsScreen> createState() => _AddMedicationsScreenState();
}

class _AddMedicationsScreenState extends State<AddMedicationsScreen> {
  final List<TextEditingController> _medicationControllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers from currentValue or with five empty fields
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      for (var med in widget.currentValue!) {
        _medicationControllers.add(TextEditingController(text: med));
        _focusNodes.add(FocusNode());
      }
      // Top up to at least 5 fields if fewer were restored
      while (_medicationControllers.length < 5) {
        _medicationControllers.add(TextEditingController());
        _focusNodes.add(FocusNode());
      }
    } else {
      for (int i = 0; i < 5; i++) {
        _medicationControllers.add(TextEditingController());
        _focusNodes.add(FocusNode());
      }
    }
  }

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

  // ✅ Static question/description overrides (no API on this page)
  String get _question => 'Add your medications or supplements';
  String get _description =>
      'If you\'re not sure, still figuring it out, or would rather answer later, '
      'that\'s totally okay. You can update this anytime in your Health Profile.';

  // ✅ FoxxTextField-based input field with optional remove icon
  Widget _buildMedicationField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: FoxxTextField(
        hintText: 'Medication or supplement name',
        controller: _medicationControllers[index],
        focusNode: _focusNodes[index],
        size: FoxxTextFieldSize.singleLine,
        onChanged: (_) => setState(() {}),
        rightIcons: [
        ],
      ),
    );
  }

  // ✅ Next handler: collect non-empty entries and move forward
  void _onNext() {
    final medications = _medicationControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    widget.onDataUpdate?.call(medications);
    FocusScope.of(context).unfocus();
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Stack layout with consistent padding and anchored Next button
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.textBoxHorizontalWidget,
            0,
            AppSpacing.textBoxHorizontalWidget,
            AppSpacing.s80, // reserve space for Next button
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingQuestionHeader(
                questions: widget.questions, // unused; override applies
                questionType: 'ADD_MEDICATIONS', // placeholder
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              // Dynamic list of entry fields
              ...List.generate(
                _medicationControllers.length,
                (index) => _buildMedicationField(index),
              ),
              // “+ Add Item” action using SelectableOptionCard for consistent look
              SelectableOptionCard(
                label: '+ Add Item',
                isSelected: false,
                isMultiSelect: false, // no check icon for a simple action
                variant: SelectableOptionVariant.brandColor,
                onTap: _addMedicationField,
              ),
            ],
          ),
        ),
        Positioned(
          left: AppSpacing.textBoxHorizontalWidget,
          right: AppSpacing.textBoxHorizontalWidget,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          child: FoxxNextButton(
            text: 'Next',
            isEnabled: true, // optional list; always enabled
            onPressed: _onNext,
          ),
        ),
      ],
    );
  }
}