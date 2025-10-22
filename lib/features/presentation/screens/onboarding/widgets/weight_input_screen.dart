import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';

class WeightInputScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final Function(double)? onDataUpdate;
  final List<OnboardingQuestion>? questions;
  final double? currentValue; // ✅ Previously entered weight

  const WeightInputScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.questions,
    this.currentValue,
  });

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  late final FocusNode _weightFocusNode;

  @override
  void initState() {
    super.initState();
    _weightFocusNode = FocusNode();

    // ✅ Pre-fill weight if currentValue exists
    if (widget.currentValue != null) {
      _weightController.text = widget.currentValue!.toStringAsFixed(0);
    }

    // Auto-show keyboard when screen loads
    Future.delayed(Duration.zero, () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_weightFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  double? getWeight() {
    if (_weightController.text.isEmpty) return null;
    return double.tryParse(_weightController.text);
  }

  bool hasTextInput() => _weightController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final weightQuestion =
        OnboardingCubit().getQuestionByType(widget.questions ?? [], 'WEIGHT');

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: AppSpacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingQuestionHeader(
              questions: widget.questions ?? const [],
              questionType: 'WEIGHT',
              questionOverride:
                  weightQuestion == null ? 'Your current weight' : null,
              descriptionOverride: weightQuestion == null
                  ? 'Knowing your weight helps us better understand patterns in your health and tailor insights to you.'
                  : null,
            ),
            // 🏋️ Weight Input
            FoxxTextField(
              controller: _weightController,
              focusNode: _weightFocusNode, // external focus node
              hintText: '0',
              size: FoxxTextFieldSize.singleLine,
              unitLabel: 'lbs',
              keyboardType: TextInputType.number,
              numericOnly: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              showClearButton: false,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FoxxNextButton(
                isEnabled: hasTextInput(),
                onPressed: () {
                  final weight = getWeight();
                  if (weight != null) {
                    widget.onDataUpdate?.call(weight);
                  }
                  FocusScope.of(context).unfocus();
                  widget.onNext?.call();
                },
                text: 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}