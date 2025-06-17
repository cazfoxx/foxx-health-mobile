import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/save_health_assessment.dart';
import 'package:foxxhealth/features/data/models/income_range_model.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/area_of_concern_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class HouseholdIncomeScreen extends StatefulWidget {
  const HouseholdIncomeScreen({Key? key}) : super(key: key);

  @override
  State<HouseholdIncomeScreen> createState() => _HouseholdIncomeScreenState();
}

class _HouseholdIncomeScreenState extends State<HouseholdIncomeScreen> {
  IncomeRange? selectedIncome;
  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'HealthAssessmentHouseholdIncomeScreen',
      screenClass: 'HealthAssessmentHouseholdIncomeScreen',
    );
  }
  @override
  void initState() {
    super.initState();
    _logScreenView();
    // Fetch income ranges when screen initializes
    context.read<HealthAssessmentCubit>().fetchIncomeRanges();
  }

  void _setIncome(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();
    if (selectedIncome != null) {
      healthCubit.setSelectedIncomeRange(selectedIncome!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      onSave: () {
        SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.income);
      },
      title: 'Household Income',
      subtitle:
          'This helps us consider your full situation, like asking about affordable care or risks tied to financial circumstances.',
      progress: 0.8,
      onNext: () {
        _setIncome(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AreaOfConcernScreen(),
        )).then((value) {
          context.read<HealthAssessmentCubit>().fetchIncomeRanges();
        },);
      },
      body: BlocBuilder<HealthAssessmentCubit, HealthAssessmentState>(
        builder: (context, state) {
          if (state is HealthAssessmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HealthAssessmentError) {
            return Center(child: Text(state.message));
          }

          if (state is HealthAssessmentIncomeRangesFetched) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: state.incomeRanges.length,
              itemBuilder: (context, index) {
                final incomeRange = state.incomeRanges[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIncome = incomeRange;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedIncome == incomeRange
                              ? AppColors.amethystViolet
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        incomeRange.incomeRange,
                        style: AppTextStyles.bodyOpenSans,
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No income ranges available'));
        },
      ),
    );
  }
}
