import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/start_date_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class SymptomsSelectionSheet extends StatefulWidget {
  final Function(SymptomTrackerResponse) onSymptomSelected;

  const SymptomsSelectionSheet({
    Key? key,
    required this.onSymptomSelected,
  }) : super(key: key);

  @override
  State<SymptomsSelectionSheet> createState() => _SymptomsSelectionSheetState();
}

class _SymptomsSelectionSheetState extends State<SymptomsSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SymptomTrackerResponse> _filteredSymptoms = [];

  @override
  void initState() {
    super.initState();
    context.read<SymptomTrackerCubit>().getSymptomTrackers();
  }

  void _filterSymptoms(List<SymptomTrackerResponse> symptoms, String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSymptoms = symptoms;
      } else {
        _filteredSymptoms = symptoms
            .where((symptom) => symptom.symptomIds!.first.symptomName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymptomTrackerCubit, SymptomTrackerState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Symptoms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StartDateScreen()));
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: AppColors.amethystViolet,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                color: AppColors.lightViolet,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      if (state is SymptomTrackersLoaded) {
                        _filterSymptoms(state.symptomTrackers, query);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search symptoms',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state is SymptomTrackerLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SymptomTrackerError) {
                      return Center(child: Text(state.message));
                    } else if (state is SymptomTrackersLoaded) {
                      final symptoms = _searchController.text.isEmpty
                          ? state.symptomTrackers
                          : _filteredSymptoms;

                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: symptoms.length,
                        itemBuilder: (context, index) {
                          final symptom = symptoms[index];
                          return ListTile(
                            title: Text(
                                symptom.symptomIds?.first.symptomName ?? ''),
                            onTap: () => widget.onSymptomSelected(symptom),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('No symptoms found'));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
