import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_neumorphic.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';

class LocationScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final Function(String)? onDataUpdate;
  final List<OnboardingQuestion> questions;
  final String? currentValue;
  final ValueChanged<bool>? onEligibilityChanged;

  const LocationScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.questions = const [],
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();

  String? selectedState;
  List<String> filteredStates = [];

  static const List<String> allStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
    'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
    'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
    'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
    'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
    'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
    'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
    'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  @override
  void initState() {
    super.initState();

    // Restore previous state if provided
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      selectedState = widget.currentValue;
      _locationController.text = widget.currentValue!;
    }

    filteredStates = List.from(allStates);

    _locationController.addListener(() {
      widget.onDataUpdate?.call(_locationController.text);
      _emitEligibility();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _emitEligibility());
  }

  void _emitEligibility() {
    widget.onEligibilityChanged?.call(_locationController.text.isNotEmpty);
  }

  void _filterStates(String query, StateSetter setModalState) {
    setModalState(() {
      if (query.isEmpty) {
        filteredStates = List.from(allStates);
      } else {
        filteredStates = allStates
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showStateSelector() {
    setState(() {
      filteredStates = List.from(allStates);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.xmark),
                      ),
                      Text(
                        'Location',
                        style: AppTypography.labelLgSemibold,
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),

                // Search bar
                Container(
                  color: AppColors.lightViolet,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search state',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterStates('', setModalState);
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) => _filterStates(value, setModalState),
                    ),
                  ),
                ),

                // List of states
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStates.length,
                    itemBuilder: (context, index) {
                      final state = filteredStates[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedState = state;
                            _locationController.text = state;
                          });
                          _searchController.clear();
                          _filterStates('', setModalState);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Text(
                            state,
                            style: AppTypography.bulletBodyMd,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingQuestionHeader(
                questions: const [],
                questionType: 'ADDRESS',
                questionOverride: 'Where do you live?',
                descriptionOverride:
                    "Where you live can shape your health in real ways, whether it’s care availability, environmental factors, or local support resources.",
              ),
              const SizedBox(height: 24),
              FoxxNeumorphicCard(
                isSelected: false,
                onTap: _showStateSelector,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: AppTypography.labelMdSemibold,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _locationController,
                        focusNode: _locationFocusNode,
                        readOnly: true,
                        onTap: _showStateSelector,
                        decoration: const InputDecoration(
                          hintText: 'Select state',
                          border: InputBorder.none,
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Navigation handled by parent
            ],
          ),
        ),
      ),
    );
  }
}