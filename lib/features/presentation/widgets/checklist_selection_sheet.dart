import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/checklist_model.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class CheckListSelectionSheet extends StatefulWidget {
  final Function(ChecklistModel) onCheckListSelected;

  const CheckListSelectionSheet({
    Key? key,
    required this.onCheckListSelected,
  }) : super(key: key);

  @override
  State<CheckListSelectionSheet> createState() =>
      _CheckListSelectionSheetState();
}

class _CheckListSelectionSheetState extends State<CheckListSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ChecklistModel> _filteredCheckLists = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCheckLists);
    context.read<ChecklistCubit>().getChecklists();
  }

  void _filterCheckLists() {
    if (context.mounted) {
      final query = _searchController.text.toLowerCase();
      final state = context.read<ChecklistCubit>().state;

      if (state is ChecklistsLoaded) {
        setState(() {
          _filteredCheckLists = state.checklists
              .where(
                  (checklist) => checklist.name.toLowerCase().contains(query))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, ChecklistState>(
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
                    'Check List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle create action through cubit
                      final cubit = context.read<ChecklistCubit>();
                      cubit.createChecklist();
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(color: AppColors.amethystViolet),
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
                    decoration: InputDecoration(
                      hintText: 'Enter',
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
                    if (state is ChecklistLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChecklistError) {
                      return Center(child: Text(state.message));
                    } else if (state is ChecklistsLoaded) {
                      final checklists = _filteredCheckLists.isEmpty &&
                              _searchController.text.isEmpty
                          ? state.checklists
                          : _filteredCheckLists;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: checklists.length,
                        itemBuilder: (context, index) {
                          final checklist = checklists[index];
                          return ListTile(
                            leading: const Icon(Icons.checklist,
                                color: AppColors.amethystViolet),
                            title: Text(checklist.name),
                            subtitle: Text('Last Edited: '),
                            onTap: () =>
                                widget.onCheckListSelected(checklist),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('No checklists available'));
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
