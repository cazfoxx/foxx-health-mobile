import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class AgeSelectionRevampScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final Function(int)? onDataUpdate;
  final List<OnboardingQuestion>? questions;
  final int? currentValue; // ✅ Previously entered age
  final ValueChanged<bool>? onEligibilityChanged;

  const AgeSelectionRevampScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.questions,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<AgeSelectionRevampScreen> createState() =>
      _AgeSelectionRevampScreenState();
}

class _AgeSelectionRevampScreenState extends State<AgeSelectionRevampScreen> {
  final TextEditingController _ageController = TextEditingController();
  late final FocusNode _ageFocusNode;
  String? _errorText; // track error

  void _emitEligibility() {
    final valid = hasTextInput() && _errorText == null;
    widget.onEligibilityChanged?.call(valid);
  }

  @override
  void initState() {
    super.initState();
    _ageFocusNode = FocusNode();

    // Restore previous age if provided
    if (widget.currentValue != null) {
      _ageController.text = widget.currentValue!.toString();
    }

    // Auto-focus age field and emit initial eligibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_ageFocusNode);
      }
      _emitEligibility();
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  int? getSelectedAge() {
    if (_ageController.text.isEmpty) return null;
    return int.tryParse(_ageController.text);
  }

  bool hasTextInput() => _ageController.text.isNotEmpty;

  void _validateAge(String value) {
    final age = int.tryParse(value);
    if (age == null) {
      _errorText = null; // empty input
    } else if (age < 18) {
      _errorText = "Our app is for users age 18+";
    } else {
      _errorText = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageQuestion =
        OnboardingCubit().getQuestionByType(widget.questions ?? [], 'AGE');

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: AppSpacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧭 Header
            OnboardingQuestionHeader(
              questions: widget.questions ?? const [],
              questionType: 'AGE',
              questionOverride:
                  ageQuestion == null ? 'Your age matters' : null,
              descriptionOverride: ageQuestion == null
                  ? 'Age can impact how symptoms show up and change over time—knowing yours helps us get it right.'
                  : null,
            ),

            // 🧍‍♀️ Age Input
            FoxxTextField(
              controller: _ageController,
              focusNode: _ageFocusNode,
              hintText: '0',
              size: FoxxTextFieldSize.singleLine,
              unitLabel: 'Years',
              keyboardType: TextInputType.number,
              numericOnly: true,
              inputFormatters: [LengthLimitingTextInputFormatter(3)],
              errorText: _errorText,
              showClearButton: false,
              onChanged: (value) {
                setState(() {
                  _validateAge(value);
                  final selectedAge = getSelectedAge();
                  if (selectedAge != null && _errorText == null) {
                    widget.onDataUpdate?.call(selectedAge);
                  }
                  _emitEligibility();
                });
              },
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}