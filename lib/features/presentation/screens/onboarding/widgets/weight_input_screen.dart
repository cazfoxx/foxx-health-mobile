import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';


class WeightInputScreen extends StatefulWidget {
  final VoidCallback? onNext;
  
  const WeightInputScreen({super.key, this.onNext});

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the weight field when screen loads
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_weightFocusNode);
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

  bool hasTextInput() {
    return _weightController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your current weight',
                style: AppHeadingTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                'Knowing your weight helps us better understand patterns in your health and tailor insights to you.',
                style: AppOSTextStyles.osMd.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        focusNode: _weightFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Text(
                      'lbs',
                      style: AppTextStyles.bodyOpenSans.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FoxxNextButton(
                  isEnabled: hasTextInput(),
                  onPressed: (){
                    // Close keyboard
                    FocusScope.of(context).unfocus();
                    widget.onNext?.call();
                  }, text: 'Next')
              ),
            ],
          ),
        ),

    );
  }
}