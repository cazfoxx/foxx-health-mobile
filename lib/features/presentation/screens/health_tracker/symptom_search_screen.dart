import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';


class SymptomSearchScreen extends StatefulWidget {
  const SymptomSearchScreen({Key? key}) : super(key: key);

  @override
  State<SymptomSearchScreen> createState() => _SymptomSearchScreenState();
}

class _SymptomSearchScreenState extends State<SymptomSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<SymptomSearchCubit>();
      if (cubit.hasMore && cubit.state is! SymptomSearchLoadingMore) {
        // Load more based on current filter
        if (cubit.selectedFilter.isEmpty) {
          cubit.loadMoreSymptoms();
        } else {
          cubit.loadMoreSymptomsByFilter();
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the cubit when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SymptomSearchCubit>();
      if (cubit.state is SymptomSearchInitial) {
        cubit.loadInitialSymptoms();
      }
    });
    
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar
              _buildTopNavigationBar(),
              
              // Filter Section
              _buildFilterSection(),
              
              // Symptoms List
              Expanded(
                child: _buildSymptomsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        gradient: RadialGradient(colors: [Color(0xffE0CDFA), AppColors.amethystViolet], radius: 10)
      ),
      child: Row(
        children: [
          // Back Button
          FoxxBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          
          // Search Bar
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.gray200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.search,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        context.read<SymptomSearchCubit>().updateSearchQuery(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter symptom name',
                        hintStyle: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.gray400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppOSTextStyles.osMd.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return BlocBuilder<SymptomSearchCubit, SymptomSearchState>(
      builder: (context, state) {
        final cubit = context.read<SymptomSearchCubit>();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter',
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              const SizedBox(height: 12),
              
              // Horizontal Scrollable Filter Buttons
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = cubit.filterOptions[index];
                    final isSelected = filter == 'All' ? cubit.selectedFilter.isEmpty : cubit.selectedFilter == filter;
                    
                    return GestureDetector(
                      onTap: () {
                        if (filter == 'All') {
                          cubit.clearFilter();
                        } else {
                          cubit.loadSymptomsByFilter(filter);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.amethyst : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.amethyst : AppColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                              color: isSelected ? Colors.white : AppColors.primary01,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSymptomsList() {
    return BlocBuilder<SymptomSearchCubit, SymptomSearchState>(
      builder: (context, state) {
        if (state is SymptomSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (state is SymptomSearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<SymptomSearchCubit>().loadInitialSymptoms();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is SymptomSearchLoaded) {
          final symptoms = state.symptoms;
          final selectedSymptoms = state.selectedSymptoms;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: symptoms.length + (state.symptoms.length < 100 ? 1 : 0), // Simplified pagination check
              itemBuilder: (context, index) {
                if (index == symptoms.length) {
                  // Loading indicator for pagination
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final symptom = symptoms[index];
                final isSelected = selectedSymptoms.contains(symptom);
                
                return GestureDetector(
                  onTap: () {
                    context.read<SymptomSearchCubit>().toggleSymptomSelection(symptom);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: AppColors.glassCardDecoration,
                    child: Row(
                      children: [
                        // Radio Button
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.amethyst : Colors.transparent,
                            border: Border.all(
                              color: AppColors.amethyst,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        
                        // Symptom Text
                        Expanded(
                          child: Text(
                            symptom.name,
                            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                              color: AppColors.primary01,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        
        return const Center(
          child: Text('No symptoms found'),
        );
      },
    );
  }
}
