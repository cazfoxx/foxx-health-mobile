import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den/commuity_den_block.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den/community_den_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den/community_den_state.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/den_detail_screen.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/request_den/request_den_screen.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_search_bar.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

// Define the data for the category grid
class DenTopic {
  final String title;
  final String svgPath; // Placeholder for actual SVG data

  DenTopic({required this.title, required this.svgPath});
}

// List of all topics with placeholder icons/SVGs
final List<DenTopic> allTopics = [
  DenTopic(title: "Autoimmune", svgPath: DenIcons.autoimmune),
  DenTopic(title: "Bone Health", svgPath: DenIcons.bone),
  DenTopic(title: "Breast Health", svgPath: DenIcons.breast),
  DenTopic(title: "Chronic Pain", svgPath: DenIcons.chronicPain),
  DenTopic(title: "Diabetes", svgPath: DenIcons.diabetes),
  DenTopic(title: "FoXx", svgPath: DenIcons.foxx), // Placeholder name/icon
  DenTopic(title: "General Health", svgPath: DenIcons.generalHealth),
  DenTopic(title: "Heart Health", svgPath: DenIcons.heartHealth),
  DenTopic(title: "Hormone Health", svgPath: DenIcons.hormoneHealth),
  DenTopic(title: "Maternal Health", svgPath: DenIcons.maternalHealth),
  DenTopic(title: "Mental Health", svgPath: DenIcons.mentalHealth),
  DenTopic(title: "Patient Advocacy", svgPath: DenIcons.patientAdvocacy),
  DenTopic(title: "Pelvic Health", svgPath: DenIcons.pelvicHealth),
  DenTopic(title: "Reproductive Health", svgPath: DenIcons.reproductiveHealth),
  DenTopic(title: "Respiratory Health", svgPath: DenIcons.respiratoryHealth),
  DenTopic(title: "Sexual Health", svgPath: DenIcons.sexualHealth),
];

// --- SCREEN IMPLEMENTATION ---

class ExploreDenScreen extends StatefulWidget {
  const ExploreDenScreen({super.key});

  @override
  State<ExploreDenScreen> createState() => _ExploreDenScreenState();
}

class _ExploreDenScreenState extends State<ExploreDenScreen> {
  CommunityDenRepository repository = CommunityDenRepository();
  late CommunityDenBloc _bloc;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  initState() {
    super.initState();
    _bloc = CommunityDenBloc(CommunityDenRepository());
    _bloc.add(FetchCommunityDens());
    // fetchDens();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _bloc.close();
    super.dispose();
  }

  // fetchDens() async {
  //   // Simulate fetching data
  //   await repository.getCommunityDens();
  //   setState(() {
  //     // Update state if needed
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Foxxbackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody:
              true, // Allows the body to extend behind the navigation bar
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. App Bar and Search
                DenSearchBar(
                  hintText: "Search den topic",
                  onChanged: (value) {
                    _debouncer.call(() {
                      if (value.isEmpty) {
                        _bloc.add(ClearSearchCommunityDens());
                        log("called clear search");
                      } else {
                        _bloc.add(SearchCommunityDens(search: value));
                      }
                    });
                  },
                ),

                // 2. Title and Request Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(top: 16, bottom: 8),
                  child: const SectionHeader(),
                ),

                // 3. Grid View for Topics (Dens)
                BlocBuilder<CommunityDenBloc, CommunityDenState>(
                  builder: (context, state) {
                    if (state is CommunityDenLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CommunityDenLoaded) {
                      final dens = state.dens;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(
                                bottom: 100), // Account for bottom nav bar
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio:
                                  0.75, // Adjust for icon and two lines of text
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: dens.length,
                            itemBuilder: (context, index) {
                              return DenTopicCard(den: dens[index]);
                            },
                          ),
                        ),
                      );
                    } else if (state is CommunityDenError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No data found.'));
                  },
                ),
              ],
            ),
          ),
          // 4. Custom Bottom Navigation Bar
          // bottomNavigationBar: const CustomBottomNavBar(),
        ),
      ),
    );
  }
}

// class ExploreDenScreen extends StatefulWidget {
//   const ExploreDenScreen({super.key});

//   @override
//   State<ExploreDenScreen> createState() => _ExploreDenScreenState();
// }

// class _ExploreDenScreenState extends State<ExploreDenScreen> {
//   late CommunityDenBloc _bloc;
//   final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

//   @override
//   void initState() {
//     super.initState();
//     _bloc = CommunityDenBloc(CommunityDenRepository());
//     _bloc.add(FetchCommunityDens());
//   }

//   @override
//   void dispose() {
//     _debouncer.cancel();
//     _bloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _bloc,
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Explore Dens")),
//         body: Column(
//           children: [
//             // Search Field
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 decoration: const InputDecoration(
//                   hintText: "Search den topic...",
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   _debouncer.call(() {
//                     if (value.isEmpty) {
//                       _bloc.add(ClearSearchCommunityDens());
//                     } else {
//                       _bloc.add(SearchCommunityDens(query: value));
//                     }
//                   });
//                 },
//               ),
//             ),

//             // Bloc Consumer
//             Expanded(
//               child: BlocBuilder<CommunityDenBloc, CommunityDenState>(
//                 builder: (context, state) {
//                   if (state is CommunityDenLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is CommunityDenLoaded) {
//                     if (state.dens.isEmpty) {
//                       return const Center(child: Text("No dens found."));
//                     }
//                     return ListView.builder(
//                       itemCount: state.dens.length,
//                       itemBuilder: (context, index) {
//                         final den = state.dens[index];
//                         return ListTile(
//                           title: Text(den.name),
//                           subtitle: Text(den.description ?? ''),
//                         );
//                       },
//                     );
//                   } else if (state is CommunityDenError) {
//                     return Center(child: Text("Error: ${state.message}"));
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// --- WIDGET COMPONENTS ---
// Custom Widget for each Den/Topic in the grid
class DenTopicCard extends StatelessWidget {
  final CommunityDenModel den;
  final double height;
  final double width;

  const DenTopicCard(
      {super.key, required this.den, this.height = 70, this.width = 70});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DenDetailScreen(den: den),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          SizedBox(
            width: height,
            height: width,
            child: Center(
              // Use the custom SVG icon defined in DenIcons class
              child: SvgPicture.asset(
                den.svgPath ?? DenIcons.foxx, // Fallback to default if null
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            den.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Widget for the "All dens" title and "Request" button
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "All dens",
          style: AppHeadingTextStyles.h2.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            // Handle request button press
            showRequestDenSheet(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF7551D6),
            backgroundColor: Colors.white.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              // side: const BorderSide( width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            "Request",
            style: AppOSTextStyles.osMd.copyWith(),
          ),
        ),
      ],
    );
  }
}

// Widget for the Back button and Search Bar
// class TopSearchAndHeader extends StatelessWidget {
//   const TopSearchAndHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.lightViolet,
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//       child: Row(
//         children: [
//           // Back Button

//           const FoxxBackButton(),

//           const SizedBox(width: 12),
//           // Search Field
//           Expanded(
//             child: Container(
//               height: 42,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: Colors.grey.shade200, width: 1),
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search, color: Color(0xFF4A4458)),
//                   hintText: "Search den topic",
//                   hintStyle: TextStyle(color: Color(0xFF4A4458)),
//                   border: InputBorder.none,
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//                 ),
//                 style: TextStyle(color: Color(0xFF4A4458)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DenIcons {
  // Autoimmune Health
  static const String autoimmune = "assets/svg/dens/auto_immune_health.svg";

  // Bone Health
  static const String bone = "assets/svg/dens/bone_health.svg";

  // Breast Health
  static const String breast = "assets/svg/dens/breast_health.svg";

  // Chronic Pain
  static const String chronicPain = "assets/svg/dens/chronic_pain.svg";

  // Diabetes (
  static const String diabetes = "assets/svg/dens/diabetes.svg";

  // FoXx (
  static const String foxx = "assets/svg/dens/default_foxx.svg";

  // General Health
  static const String generalHealth = "assets/svg/dens/default_foxx.svg";

  // Heart Health
  static const String heartHealth = "assets/svg/dens/heart_health.svg";

  // Hormone Health
  static const String hormoneHealth = "assets/svg/dens/hormone_health.svg";

  // Maternal Health
  static const String maternalHealth = "assets/svg/dens/maternal_health.svg";

  // Mental Health
  static const String mentalHealth = "assets/svg/dens/mental_health.svg";

  // Patient Advocacy
  static const String patientAdvocacy = "assets/svg/dens/patient_advocacy.svg";

  // Pelvic Health
  static const String pelvicHealth = "assets/svg/dens/pelvic_health.svg";

  // Reproductive Health
  static const String reproductiveHealth =
      "assets/svg/dens/reproductive_health.svg";

  // Respiratory Health
  static const String respiratoryHealth =
      "assets/svg/dens/respiratory_health.svg";

  // Sexual Health
  static const String sexualHealth = "assets/svg/dens/sexual_health.svg";
}
