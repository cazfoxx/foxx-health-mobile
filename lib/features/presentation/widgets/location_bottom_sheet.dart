import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/state_model.dart'
    as state_model;
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class LocationBottomSheet extends StatefulWidget {
  final List<state_model.State> states;
  final Function(state_model.State) onStateSelected;

  const LocationBottomSheet({
    Key? key,
    required this.states,
    required this.onStateSelected,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required List<state_model.State> states,
    required Function(state_model.State) onStateSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationBottomSheet(
        states: states,
        onStateSelected: onStateSelected,
      ),
    );
  }

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<state_model.State> filteredStates;

  @override
  void initState() {
    super.initState();
    filteredStates = List<state_model.State>.from(widget.states);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredStates = widget.states
          .where((state) =>
              state.stateName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(CupertinoIcons.xmark),
                    ),
                    Text(
                      'Location',
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.lightViolet,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search state',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: filteredStates.length,
              itemBuilder: (context, index) {
                final state = filteredStates[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    state.stateName,
                    style: AppTextStyles.bodyOpenSans,
                  ),
                  onTap: () {
                    widget.onStateSelected(state);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
