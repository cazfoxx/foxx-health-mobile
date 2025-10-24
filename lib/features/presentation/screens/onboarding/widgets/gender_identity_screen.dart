import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class GenderIdentityScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;
  final String? currentValue; // ✅ Previously selected gender
  final ValueChanged<bool>? onEligibilityChanged;

  const GenderIdentityScreen({
    super.key,
    this.onNext,
    required this.questions,
    this.onDataUpdate,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<GenderIdentityScreen> createState() => _GenderIdentityScreenState();
}

class _GenderIdentityScreenState extends State<GenderIdentityScreen> {
  String? _selectedGender;

  /// Controller for self-describe input
  final TextEditingController _selfDescribeController = TextEditingController();

  /// Tracks if self-describe option is selected
  bool _isSelfDescribeSelected = false;

  /// Stores previously entered self-describe input to restore when reselecting
  String? _previousSelfDescribeText;

  @override
  void initState() {
    super.initState();

    final cv = widget.currentValue?.trim();
    if (cv == null || cv.isEmpty) {
      _selectedGender = null;
      _isSelfDescribeSelected = false;
    } else {
      final options = _genderOptions;
      final matchesOption = options.any(
        (o) => o.trim().toLowerCase() == cv.toLowerCase(),
      );
      if (matchesOption) {
        _selectedGender = cv;
        _isSelfDescribeSelected = _isSelfDescribeLabel(cv);
      } else {
        _isSelfDescribeSelected = true;
        final selfDescribeLabel = options.firstWhere(
          (o) => _isSelfDescribeLabel(o),
          orElse: () => 'Prefer to self describe',
        );
        _selectedGender = selfDescribeLabel;
        _selfDescribeController.text = cv;
      }
    }

    _selfDescribeController.addListener(() {
      widget.onDataUpdate?.call(_selfDescribeController.text.trim());
      _emitEligibility();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _emitEligibility());
  }

  List<String> get _genderOptions {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'GENDER');
    final cached = OnboardingCubit.cachedChoicesByType['GENDER'];
    final apiChoices = (question?.choices.isNotEmpty ?? false) ? question!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
            'Woman',
            'Transgender Woman',
            'Gender queer/Gender fluid',
            'Agender',
            'Prefer not to say',
            'Prefer to self describe',
          ];
  }

  String get _description {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'GENDER');
    return question?.description ?? 'How do you currently describe your gender identity?';
  }

  bool _isSelfDescribeLabel(String label) {
    final l = label.toLowerCase();
    return l.contains('self describe') || l.contains('self-describe');
  }

  bool hasValidSelection() {
    final value = _isSelfDescribeSelected
        ? _selfDescribeController.text.trim()
        : _selectedGender;
    return value != null && value.isNotEmpty;
  }

  void _emitEligibility() {
    widget.onEligibilityChanged?.call(hasValidSelection());
  }

  Widget _buildOptionCard(String label) {
    final isSelfDescribe = _isSelfDescribeLabel(label);
    final isSelected = isSelfDescribe ? _isSelfDescribeSelected : _selectedGender == label;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: SelectableOptionCard(
        label: label,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            if (isSelfDescribe) {
              _selectedGender = label;
              _isSelfDescribeSelected = true;

              // Restore previous self-describe text if available
              if (_previousSelfDescribeText != null) {
                _selfDescribeController.text = _previousSelfDescribeText!;
              }
            } else {
              _selectedGender = label;

              // Save text before clearing
              if (_isSelfDescribeSelected) {
                _previousSelfDescribeText = _selfDescribeController.text;
              }

              _isSelfDescribeSelected = false;
              _selfDescribeController.clear();
            }
          });
        },
        isMultiSelect: false,
        variant: SelectableOptionVariant.brandSecondary,
      ),
    );
  }

  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _isSelfDescribeSelected,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: 'Please specify',
          size: FoxxTextFieldSize.singleLine,
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selfDescribeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = hasValidSelection();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.textBoxHorizontalWidget,
            0,
            AppSpacing.textBoxHorizontalWidget,
            AppSpacing.s80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingQuestionHeader(
                questions: widget.questions,
                questionType: 'GENDER',
                descriptionOverride: _description,
              ),
              ..._genderOptions.expand((label) => [
                    _buildOptionCard(label),
                    if (_isSelfDescribeLabel(label)) _buildSelfDescribeField(),
                  ]).toList(),
            ],
          ),
        ),

      ],
    );
  }
}