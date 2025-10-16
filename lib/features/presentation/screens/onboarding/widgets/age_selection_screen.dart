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

  const AgeSelectionRevampScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.questions,
    this.currentValue,
  });

  @override
  State<AgeSelectionRevampScreen> createState() =>
      _AgeSelectionRevampScreenState();
}

class _AgeSelectionRevampScreenState extends State<AgeSelectionRevampScreen> {
  final TextEditingController _ageController = TextEditingController();
  late final FocusNode _ageFocusNode;
  String? _errorText; // track error

  @override
  void initState() {
    super.initState();
    _ageFocusNode = FocusNode();
    // ✅ Pre-fill age if currentValue exists
    if (widget.currentValue != null) {
      _ageController.text = widget.currentValue!.toString();
    }

    // Auto-show keyboard when screen loads
    Future.delayed(Duration.zero, () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_ageFocusNode);
      }
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
              focusNode: _ageFocusNode, // external focus node
              hintText: '0',
              size: FoxxTextFieldSize.singleLine,
              unitLabel: 'Years',
              keyboardType: TextInputType.number, // numeric keyboard
              numericOnly: true,
              inputFormatters: [LengthLimitingTextInputFormatter(3)],
              errorText: _errorText, // auto-highlight on error
              showClearButton: false,
              onChanged: (value) {
                setState(() {
                  _validateAge(value);
                });
              },
            ),

            const Spacer(),

            // 🟣 Next Button
            SizedBox(
              width: double.infinity,
              child: FoxxNextButton(
                text: 'Next',
                isEnabled: hasTextInput() && _errorText == null,
                onPressed: () {
                  final selectedAge = getSelectedAge();
                  if (selectedAge != null && _errorText == null) {
                    widget.onDataUpdate?.call(selectedAge);
                    FocusScope.of(context).unfocus();
                    widget.onNext?.call();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}