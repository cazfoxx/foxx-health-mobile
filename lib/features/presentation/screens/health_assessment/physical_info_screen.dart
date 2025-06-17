import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/save_health_assessment.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/location_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PhysicalInfoScreen extends StatefulWidget {
  const PhysicalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalInfoScreen> createState() => _PhysicalInfoScreenState();
}

class _PhysicalInfoScreenState extends State<PhysicalInfoScreen> {
  final _feetController = TextEditingController();
  final _inchController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'PhysicalInfoScreen',
      screenClass: 'PhysicalInfoScreen',
    );
  }

  String? _ageError;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _logScreenView();
    _feetController.addListener(_validateForm);
    _inchController.addListener(_validateForm);
    _weightController.addListener(_validateForm);
    _ageController.addListener(_validateAge);
  }

  void _validateAge() {
    final age = int.tryParse(_ageController.text);
    setState(() {
      if (_ageController.text.isEmpty) {
        _ageError = 'Age is required';
      } else if (age != null && age < 16) {
        _ageError = 'Must be 16 or older';
      } else {
        _ageError = null;
      }
      _validateForm();
    });
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _feetController.text.isNotEmpty &&
          _inchController.text.isNotEmpty &&
          _weightController.text.isNotEmpty &&
          _ageController.text.isNotEmpty &&
          _ageError == null;
    });
  }

  void _setHealthAssessmentValues(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();

    // Convert feet and inches to total inches
    final feet = int.tryParse(_feetController.text) ?? 0;
    final inches = int.tryParse(_inchController.text) ?? 0;


    // Set values to cubit
    healthCubit.setHeightInInches(inches);
    healthCubit.setHeightInFeet(feet);

    healthCubit.setUserWeight(int.tryParse(_weightController.text) ?? 0);
    healthCubit.setAge(int.tryParse(_ageController.text) ?? 0);
  }

  

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      resizeToAvoidBottomInset: true,
      title: 'Your Physical Information',
      subtitle: 'Help us create health assessment with your physical data',
      progress: 0.2,
      onSave: (){
        SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.physicalInfo);
      },
      onNext: () {
        _setHealthAssessmentValues(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LocationScreen()));
      },
      isNextEnabled: _isFormValid,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputSection(
            'Height',
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feetController,
                    decoration: InputDecoration(
                      hintText: 'Feet',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _inchController,
                    decoration: InputDecoration(
                      hintText: 'Inch',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          _buildInputSection(
            'Weight',
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                hintText: 'lbs',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          _buildInputSection(
            'Age',
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: 'Years',
                filled: true,
                fillColor: Colors.white,
                errorText: _ageError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(String label, Widget input) {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          input,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
