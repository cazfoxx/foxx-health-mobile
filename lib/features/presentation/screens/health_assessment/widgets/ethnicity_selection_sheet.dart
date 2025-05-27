import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class EthnicitySelectionSheet extends StatefulWidget {
  final List<String> selectedEthnicities;

  const EthnicitySelectionSheet({
    Key? key,
    required this.selectedEthnicities,
  }) : super(key: key);

  @override
  State<EthnicitySelectionSheet> createState() =>
      _EthnicitySelectionSheetState();
}

class _EthnicitySelectionSheetState extends State<EthnicitySelectionSheet> {
  late List<String> _selectedEthnicities;

  final List<String> ethnicities = [
    'Indigenous or Alaska Native',
    'Black or African American',
    'East & South East Asian',
    'Native Hawaiian or Pacific Islander',
    'South Asian',
    'Latino/ Hispanic',
    'Middle Eastern/ North African',
    'White or European American',
    'Prefer not to answer',
  ];

  @override
  void initState() {
    super.initState();
    _selectedEthnicities = List.from(widget.selectedEthnicities);
  }

  void _updateEthnicities() {
    if (_selectedEthnicities.isNotEmpty) {
      context
          .read<HealthAssessmentCubit>()
          .setEthnicities(_selectedEthnicities);
      context.read<HealthAssessmentCubit>().updateHealthAssessment();
      SnackbarUtils.showSuccess(
          context: context, title: 'Success!', message: 'Information updated');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one ethnicity')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Select Ethnicities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Divider(),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ethnicities.length,
              itemBuilder: (context, index) {
                final ethnicity = ethnicities[index];
                return CheckboxListTile(
                  title: Text(ethnicity),
                  value: _selectedEthnicities.contains(ethnicity),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected ?? false) {
                        _selectedEthnicities.add(ethnicity);
                      } else {
                        _selectedEthnicities.remove(ethnicity);
                      }
                    });
                  },
                  activeColor: AppColors.amethystViolet,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateEthnicities,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amethystViolet,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Update'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
