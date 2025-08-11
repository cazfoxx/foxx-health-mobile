// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:foxxhealth/core/services/analytics_service.dart';
// import 'package:foxxhealth/core/utils/save_health_assessment.dart';
// import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
// import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
// import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
// import 'package:foxxhealth/features/presentation/screens/health_assessment/ethnicity_screen.dart';
// import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
// import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';


// class LocationScreen extends StatefulWidget {
//   const LocationScreen({Key? key}) : super(key: key);

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   final _locationController = TextEditingController();
//   final _searchController = TextEditingController();
//   String? selectedState;
//   List<String> filteredStates = [];
//   final _analytics = AnalyticsService();

//   static const List<String> allStates = [
//     'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
//     'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
//     'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
//     'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
//     'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
//     'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
//     'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
//     'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
//     'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
//     'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
//   ];

//   Future<void> _logScreenView() async {
//     await _analytics.logScreenView(
//       screenName: 'HealthAssessmentLocationScreen',
//       screenClass: 'HealthAssessmentLocationScreen',
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _logScreenView();
//     filteredStates = List.from(allStates);
//   }

//   void _filterStates(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredStates = List.from(allStates);
//       } else {
//         filteredStates = allStates
//             .where((state) => state.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   void _showStateSelector() {
//     setState(() {
//       filteredStates = List.from(allStates);
//     });

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => Container(
//           height: MediaQuery.of(context).size.height * 0.9,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: Icon(CupertinoIcons.xmark)),
//                         Text(
//                           'Location',
//                           style: AppTextStyles.bodyOpenSans.copyWith(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(width: 50)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 color: AppColors.lightViolet,
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search state',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: _searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 setState(() {
//                                   _searchController.clear();
//                                   _filterStates('');
//                                 });
//                               },
//                             )
//                           : null,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _filterStates(value);
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredStates.length,
//                   itemBuilder: (context, index) {
//                     final state = filteredStates[index];
//                     return InkWell(
//                       onTap: () {
//                         this.setState(() {
//                           selectedState = state;
//                           _locationController.text = state;
//                         });
//                         // Save to cubit
//                         context.read<HealthAssessmentCubit>().setLocation(state);
//                         _searchController.clear();
//                         _filterStates('');
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(color: Colors.grey[200]!),
//                           ),
//                         ),
//                         child: Text(
//                           state,
//                           style: AppTextStyles.bodyOpenSans,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HeaderWidget(
//       onSave: () {
//         SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.location);
//       },
//       title: 'Where do you live?',
//       subtitle:'',
//       progress: 0.4,
//       customSubtile: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text('Why we ask :', style: AppTextStyles.body2OpenSans.copyWith(fontWeight: FontWeight.w700),),
//           Text(
//             'Where you live can impact your health. For example, people living in certain areas are more likely to experience things like vitamin D deficiency. Knowing your location helps us make our recommendations more accurate',
//             style: AppTextStyles.body2OpenSans,
//           ),
//         ],
//       ),
//       onNext: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => EthnicityScreen()));
//       },
//       isNextEnabled: selectedState != null,
//       body: GestureDetector(
//         onTap: _showStateSelector,
//         child: Container(
//           padding: const EdgeInsets.all(13),
//           margin: const EdgeInsets.all(13),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Location: State, USA',
//                 style: AppTextStyles.bodyOpenSans.copyWith(
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _locationController,
//                 readOnly: true,
//                 onTap: _showStateSelector,
//                 decoration: InputDecoration(
//                   hintText: 'Select state',
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _locationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
// }
