import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';

import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';





class HeightInputScreen extends StatefulWidget {
  final VoidCallback? onNext;
  
  const HeightInputScreen({super.key, this.onNext});

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final FocusNode _feetFocusNode = FocusNode();
  final FocusNode _inchesFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the feet field when screen loads
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_feetFocusNode);
    });
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _feetFocusNode.dispose();
    _inchesFocusNode.dispose();
    super.dispose();
  }

  bool isHeightValid() {
    return _feetController.text.isNotEmpty;
  }

  bool hasTextInput() {
    return _feetController.text.isNotEmpty || _inchesController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How tall are you?',
                  style: AppHeadingTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your height helps us interpret symptom trends and offer more accurate support for your body.',
                  style: AppOSTextStyles.osMd.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _feetController,
                                focusNode: _feetFocusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_inchesFocusNode);
                                },
                              ),
                            ),
                            Text(
                              'ft',
                              style: AppTextStyles.bodyOpenSans.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _inchesController,
                                focusNode: _inchesFocusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            Text(
                              'in',
                              style: AppTextStyles.bodyOpenSans.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    },
                    text: 'Next')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}