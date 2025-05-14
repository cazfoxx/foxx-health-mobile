import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});
  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedChecklist;
  String? _selectedSymptom;

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
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
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _typeController,
                    label: 'Type of Appointment',
                    readOnly: true,
                    onTap: () async {
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.transparent,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.90,
                          maxChildSize: 0.90,
                          minChildSize: 0.5,
                          builder: (context, scrollController) => Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: const AppointmentTypeScreen(),
                          ),
                        ),
                      );
                      
                      if (result != null) {
                        setState(() {
                          _typeController.text = result;
                        });
                      }
                    },
                    suffixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  _buildAddCheckList(),
                  const SizedBox(height: 16),
                  _buildAddSymptom(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'New Appointment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement save functionality
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.amethystViolet,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Date',
              style: TextStyle(
                color: _selectedDate != null ? Colors.black : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCheckList() {
    return InkWell(
      onTap: () {
        _showCheckListBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.checklist, color: AppColors.amethystViolet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedChecklist ?? 'Add Check List',
                style: TextStyle(
                  color: _selectedChecklist != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSymptom() {
    return InkWell(
      onTap: () {
        _showSymptomsBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.healing, color: AppColors.amethystViolet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedSymptom ?? 'Add Symptoms',
                style: TextStyle(
                  color: _selectedSymptom != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCheckListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CheckListSelectionSheet(
        onCheckListSelected: (checklist) {
          setState(() {
            _selectedChecklist = checklist;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSymptomsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SymptomsSelectionSheet(
        onSymptomSelected: (symptom) {
          setState(() {
            _selectedSymptom = symptom;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class CheckListSelectionSheet extends StatefulWidget {
  final Function(String) onCheckListSelected;

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
  final List<String> _checkLists = [
    'Check List in Progress',
    'PCP Check List',
    'Oncologist Check List',
    'Check List Name',
  ];
  List<String> _filteredCheckLists = [];

  @override
  void initState() {
    super.initState();
    _filteredCheckLists = List.from(_checkLists);
    _searchController.addListener(_filterCheckLists);
  }

  void _filterCheckLists() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCheckLists = _checkLists
          .where((checklist) => checklist.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  // Handle create action
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCheckLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.checklist,
                      color: AppColors.amethystViolet),
                  title: Text(_filteredCheckLists[index]),
                  subtitle: Text('Last Edited: Apr 20, 2025'),
                  onTap: () =>
                      widget.onCheckListSelected(_filteredCheckLists[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SymptomsSelectionSheet extends StatefulWidget {
  final Function(String) onSymptomSelected;

  const SymptomsSelectionSheet({
    Key? key,
    required this.onSymptomSelected,
  }) : super(key: key);

  @override
  State<SymptomsSelectionSheet> createState() => _SymptomsSelectionSheetState();
}

class _SymptomsSelectionSheetState extends State<SymptomsSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _symptoms = [
    'Brain fog',
    'Changes in eating habits',
    'Difficulty completing tasks',
    'Sharp pain - Chest & upper back',
    'Tingling or numbness - Legs & feet',
  ];
  List<String> _filteredSymptoms = [];

  @override
  void initState() {
    super.initState();
    _filteredSymptoms = List.from(_symptoms);
    _searchController.addListener(_filterSymptoms);
  }

  void _filterSymptoms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSymptoms = _symptoms
          .where((symptom) => symptom.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              TextButton(
                onPressed: () {
                  // Handle create action
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _filteredSymptoms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredSymptoms[index]),
                  onTap: () =>
                      widget.onSymptomSelected(_filteredSymptoms[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
