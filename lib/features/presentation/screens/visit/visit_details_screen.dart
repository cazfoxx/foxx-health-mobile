import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/visit/widgets/appointment_header.dart';

class VisitDetailsScreen extends StatefulWidget {
  final String doctorName;
  final String specialization;
  final String date;

  const VisitDetailsScreen({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.date,
  });

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  // Add these new controllers and maps
  final Map<String, String> _questionNotes = {};
  final TextEditingController _noteController = TextEditingController();
  int? _selectedQuestionIndex;
  bool _isAddingNote = false;
  String _selectedSection = '';
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _suggestedQuestionController =
      TextEditingController();
  final TextEditingController _termController = TextEditingController();

  List<String> suggestedQuestions = [
    'How often should I schedule checkups?',
    'What screenings should I be getting based on my age and family history?',
    'Am I up-to-date on my immunizations?',
  ];

  List<String> personalQuestions = [
    'Do I need a flu shot?',
    'Should I be taking supplements?',
    'Do I need a new blood test?',
    'Can you explain my test results?',
  ];

  List<String> prescriptions = [];
  List<String> medicalTerms = [];

  @override
  void dispose() {
    _questionController.dispose();
    _prescriptionController.dispose();
    _suggestedQuestionController.dispose();
    _termController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _showEditBottomSheet,
            child: const Text(
              'Edit',
              style: TextStyle(
                color: AppColors.amethystViolet,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppointmentHeader(
              doctorName: widget.doctorName,
              specialization: widget.specialization,
              date: widget.date,
            ),
            Container(
              color: AppColors.lightViolet,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PCP Check List',
                        style: AppTextStyles.heading3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.amethystViolet)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSuggestedQuestions(),
            const SizedBox(height: 16),
            _buildPersonalQuestions(),
            const SizedBox(height: 16),
            _buildPrescriptionsAndSupplements(),
            const SizedBox(height: 16),
            _buildMedicalTermExplainer(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  _buildPrescriptionsAndSupplements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Prescriptions & Supplements',
            style: AppTextStyles.heading3.copyWith(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                prescriptions.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedQuestionIndex = index;
                          _isAddingNote = true;
                          _selectedSection = 'prescriptions';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              prescriptions[index],
                              textAlign: TextAlign.start, // Add this line
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (_questionNotes
                              .containsKey('prescriptions_$index'))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _questionNotes['prescriptions_$index']!,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (_selectedQuestionIndex == index &&
                              _isAddingNote &&
                              _selectedSection == 'prescriptions')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  hintText: 'Add a note',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _questionNotes['prescriptions_$index'] =
                                          value;
                                      _selectedQuestionIndex = null;
                                      _isAddingNote = false;
                                      _noteController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (index < prescriptions.length - 1)
                      const Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: TextFormField(
                  controller: _prescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add',
                    prefixIcon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        prescriptions.add(value);
                        _prescriptionController.clear();
                      });
                    }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildPersonalQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Personal Questions',
            style: AppTextStyles.heading3.copyWith(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                personalQuestions.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedQuestionIndex = index;
                          _isAddingNote = true;
                          _selectedSection = 'personal';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              personalQuestions[index],
                              textAlign: TextAlign.start,
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (_questionNotes.containsKey('personal_$index'))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _questionNotes['personal_$index']!,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (_selectedQuestionIndex == index &&
                              _isAddingNote &&
                              _selectedSection == 'personal')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  hintText: 'Add a note',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _questionNotes['personal_$index'] = value;
                                      _selectedQuestionIndex = null;
                                      _isAddingNote = false;
                                      _noteController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (index <= personalQuestions.length - 1)
                      const Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: 'Add',
                    prefixIcon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        personalQuestions.add(value);
                        _questionController.clear();
                      });
                    }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildSuggestedQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Suggested Questions',
            style: AppTextStyles.heading3.copyWith(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 13.0,
                spreadRadius: 6.0,
                color: Colors.black.withOpacity(0.09),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                suggestedQuestions.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedQuestionIndex = index;
                          _isAddingNote = true;
                          _selectedSection = 'suggested';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              suggestedQuestions[index],
                              textAlign: TextAlign.start, // Add this line
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (_questionNotes.containsKey('suggested_$index'))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _questionNotes['suggested_$index']!,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (_selectedQuestionIndex == index &&
                              _isAddingNote &&
                              _selectedSection == 'suggested')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  hintText: 'Add a note',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _questionNotes['suggested_$index'] =
                                          value;
                                      _selectedQuestionIndex = null;
                                      _isAddingNote = false;
                                      _noteController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (index < suggestedQuestions.length - 1)
                      const Divider(height: 1),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.90,
        maxChildSize: 0.90,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        blurRadius: 13.0,
                        spreadRadius: 6.0,
                        color: Colors.black.withOpacity(0.09),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Edit Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle save action
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: AppColors.amethystViolet,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              blurRadius: 13.0,
                              spreadRadius: 6.0,
                              color: Colors.black.withOpacity(0.09),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: '1st Visit with Dr Smith'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              blurRadius: 13.0,
                              spreadRadius: 6.0,
                              color: Colors.black.withOpacity(0.09),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Type of Appointment',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      DraggableScrollableSheet(
                                    initialChildSize: 0.90,
                                    maxChildSize: 0.90,
                                    minChildSize: 0.5,
                                    builder: (context, scrollController) =>
                                        Container(
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
                              },
                              controller:
                                  TextEditingController(text: 'Oncologist'),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              blurRadius: 13.0,
                              spreadRadius: 6.0,
                              color: Colors.black.withOpacity(0.09),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: TextEditingController(text: 'May 2026'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPCPCheckListSection(),
                      const SizedBox(height: 24),
                      Card(
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                // Handle delete action
                              },
                              child: const Text(
                                'Delete Appointment',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPCPCheckListSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 13.0,
            spreadRadius: 6.0,
            color: Colors.black.withOpacity(0.09),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list),
              const SizedBox(width: 8),
              const Text(
                'PCP Check List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Last Edited: Apr 20, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Divider(),
          const Text(
            'Symptoms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildSymptomChip('Changes in eating habits'),
          const SizedBox(height: 8),
          _buildSymptomChip('Chest & Upper back\nDull Pain'),
          const SizedBox(height: 16),
          Divider(),
          _buildAddButton('Add A Check List'),
          const SizedBox(height: 8),
          Divider(),
          _buildAddButton('Add Symptom'),
        ],
      ),
    );
  }

  Widget _buildSymptomChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.close,
            size: 18,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text) {
    return Row(
      children: [
        Icon(
          Icons.add_circle_outline,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  _buildMedicalTermExplainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Medical Term Explainer',
            style: AppTextStyles.heading3.copyWith(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                medicalTerms.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedQuestionIndex = index;
                          _isAddingNote = true;
                          _selectedSection = 'medical';
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  medicalTerms[index],
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_questionNotes.containsKey('medical_$index'))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _questionNotes['medical_$index']!,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (_selectedQuestionIndex == index &&
                              _isAddingNote &&
                              _selectedSection == 'medical')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: _noteController,
                                decoration: InputDecoration(
                                  hintText: 'Add a note',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _questionNotes['medical_$index'] = value;
                                      _selectedQuestionIndex = null;
                                      _isAddingNote = false;
                                      _noteController.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (index < medicalTerms.length - 1)
                      const Divider(height: 1),
                  ],
                ),
              ),
              Container(
                child: TextFormField(
                  controller: _termController,
                  decoration: InputDecoration(
                    hintText: 'Add',
                    prefixIcon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        medicalTerms.add(value);
                        _termController.clear();
                      });
                    }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
