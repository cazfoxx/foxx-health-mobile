import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class AppointmentListBottomSheet extends StatefulWidget {
  const AppointmentListBottomSheet(
      {super.key, this.isSelectionEnabled = false});
  final bool isSelectionEnabled;

  @override
  State<AppointmentListBottomSheet> createState() =>
      _AppointmentListBottomSheetState();
}

class _AppointmentListBottomSheetState
    extends State<AppointmentListBottomSheet> {
  String? _selectedType;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<String> _appointmentTypes = [
    'New Visit',
    'Yearly Check Up',
    '1st Visit with Dr Smith'
  ];
  List<String> _filteredTypes = [];

  @override
  void initState() {
    super.initState();
    _filteredTypes = List.from(_appointmentTypes);
    _textController.addListener(_filterAppointmentTypes);
  }

  void _filterAppointmentTypes() {
    final query = _textController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTypes = List.from(_appointmentTypes);
      } else {
        _filteredTypes = _appointmentTypes
            .where((type) => type.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.amethystViolet,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'Appointment',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                // Empty SizedBox to balance the back button
                const SizedBox(width: 48),
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
                controller: _textController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _textController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _filteredTypes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No appointment types found',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTypes.length,
                    itemBuilder: (context, index) {
                      final type = _filteredTypes[index];
                      return _buildTypeItem(type);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTypeItem(String type) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        // Return the selected value and pop back
        Navigator.pop(context, type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amethystViolet.withOpacity(0.1) : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  type,
                  style: AppTextStyles.body.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.amethystViolet : null,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.amethystViolet,
                  ),
              ],
            ),
            Text(
              'Last Edited: Apr 20, 2025',
              style: AppTextStyles.body2OpenSans.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
