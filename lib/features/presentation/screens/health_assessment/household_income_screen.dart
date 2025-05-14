import 'package:flutter/material.dart';
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
  String? selectedIncome;

  final List<String> incomeRanges = [
    'Less than \$25,000',
    '\$25,000 - \$50,000',
    '\$50,000 - \$75,000',
    '\$75,000 - \$100,000 +',
  ];

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Household Income',
      subtitle:
          'This helps us consider your full situation, like asking about affordable care or risks tied to financial circumstances.',
      progress: 0.8,
      onNext: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AreaOfConcernScreen(),
        ));
      },
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: incomeRanges.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIncome = incomeRanges[index];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedIncome == incomeRanges[index]
                        ? AppColors.amethystViolet
                        : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  incomeRanges[index],
                  style: AppTextStyles.bodyOpenSans,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
