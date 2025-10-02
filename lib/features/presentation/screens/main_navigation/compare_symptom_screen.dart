import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';



import 'package:flutter/material.dart';

class SymptomsDialog extends StatefulWidget {
  final List<String> symptoms;
  final DateTime date;

  const SymptomsDialog({
    Key? key,
    required this.symptoms,
    required this.date,
  }) : super(key: key);

  @override
  State<SymptomsDialog> createState() => _SymptomsDialogState();
}

class _SymptomsDialogState extends State<SymptomsDialog> {
  // Selection map: symptom name → selected/unselected
  late Map<String, bool> _selectedMap;

  @override
  void initState() {
    super.initState();
    _selectedMap = {for (var s in widget.symptoms) s: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.gray100, // dimmed background for "dialog" effect
      body: Center(
        child: Container(
          height: 1200,
          width: 600,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient header
              Container(
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.86, -0.5),
                    end: Alignment(0.86, 0.5),
                    colors: [
                      Color(0xFFE9D3FF),
                      Color(0xFFFFE5AA),
                    ],
                    stops: [0.0022, 0.9528],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text("",
                  // "Symptoms on ${widget.date.toLocal().toString().split(' ')[0]}",
                  // style: TextStyle(
                  //   color: Colors.black,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 16,
                  // ),
                ),
              ),

              // Body
              Expanded(
                child: widget.symptoms.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text("No symptoms recorded"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Compare symptoms',
                              style: TextStyle(
                                color: Color(0xFF3E3D48),
                                fontSize: 20,
                                fontFamily: 'Merriweather',
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You can layer up to 3 additional symptoms to explore connections.',
                              style: TextStyle(
                                color: Color(0xFF3E3D48),
                                fontSize: 16,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Symptoms list
                            Expanded(
                              child: ListView.separated(
                                itemCount: widget.symptoms.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final symptom = widget.symptoms[index];
                                  final isChecked =
                                      _selectedMap[symptom] ?? false;

                                  return ListTile(
                                    leading: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF9B59B6), // amethyst
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    title: Text(
                                      symptom,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMap[symptom] = !isChecked;
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF9B59B6),
                                            width: 2,
                                          ),
                                          color: isChecked
                                              ? const Color(0xFF9B59B6)
                                              : Colors.transparent,
                                        ),
                                        child: isChecked
                                            ? const Icon(Icons.check,
                                                size: 16, color: Colors.white)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class DaySymptomsScreen extends StatefulWidget {
//   final DateTime date;
//   final List<Symptom> symptoms;

//   const DaySymptomsScreen({
//     Key? key,
//     required this.date,
//     required this.symptoms,
//   }) : super(key: key);

//   @override
//   _DaySymptomsScreenState createState() => _DaySymptomsScreenState();
// }

// class _DaySymptomsScreenState extends State<DaySymptomsScreen> {
//   late Map<String, bool> _selectedMap;

//   @override
//   void initState() {
//     super.initState();
//     // initialize all symptoms unchecked
//     _selectedMap = {
//       for (var s in widget.symptoms) s.id: false,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(44), // height of the header
//         child: Container(
//           width: double.infinity, // fills screen width
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(-0.86, -0.5), // approx 328.58deg
//               end: Alignment(0.86, 0.5),
//               colors: [
//                 Color(0xFFE9D3FF), // #E9D3FF
//                 Color(0xFFFFE5AA), // #FFE5AA
//               ],
//               stops: [0.0022, 0.9528],
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16), // sheet/radius
//               topRight: Radius.circular(16), // sheet/radius
//             ),
//           ),
//           alignment: Alignment.center,
//           child: const Text(
//             '',
//             style: TextStyle(
//               color: Colors.black, // choose contrasting color
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//       body: widget.symptoms.isEmpty
//           ? const Center(child: Text("No symptoms recorded"))
//           : Container(
//               width: double.infinity,
//               padding: const EdgeInsets.only(
//                 top: 32,
//                 left: 24,
//                 right: 24,
//                 bottom: 48,
//               ),
//               decoration: const ShapeDecoration(
//                 color: Color(0xFFFFFCFC) /* sheet-color-background-light */,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(18),
//                     bottomRight: Radius.circular(18),
//                   ),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     width: 304,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 32.0),
//                       child: Text(
//                         'Compare symptoms',
//                         style: TextStyle(
//                           color: Color(0xFF3E3D48) /* text-color-primary */,
//                           fontSize: 20,
//                           fontFamily: 'Merriweather',
//                           fontWeight: FontWeight.w700,
//                           height: 1.20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 304,
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 8.0, left: 32.0),
//                       child: Text(
//                         'You can layer up to 3 addtional symptoms to explore connections.',
//                         style: TextStyle(
//                           color: Color(0xFF3E3D48) /* text-color-primary */,
//                           fontSize: 16,
//                           fontFamily: 'Open Sans',
//                           fontWeight: FontWeight.w400,
//                           height: 1.50,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Wrap ListView in Expanded
//                   Expanded(
//                     child: ListView.separated(
//                       padding: const EdgeInsets.all(16.0),
//                       itemCount: widget.symptoms.length,
//                       separatorBuilder: (context, index) => const Divider(),
//                       itemBuilder: (context, index) {
//                         final symptom = widget.symptoms[index];
//                         final isChecked = _selectedMap[symptom.id] ?? false;

//                         return ListTile(
//                           leading: Container(
//                             width: 32,
//                             height: 41,
//                             margin: const EdgeInsets.all(2),
//                             decoration: const BoxDecoration(
//                               color: AppColors.amethyst,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           title: Text(
//                             symptom.name,
//                             style: AppOSTextStyles.osMd.copyWith(
//                               color: AppColors.primary01,
//                             ),
//                           ),
//                           trailing: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _selectedMap[symptom.id] = !isChecked;
//                               });
//                             },
//                             child: Container(
//                               width: 24,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: AppColors.amethyst,
//                                   width: 2,
//                                 ),
//                                 color: isChecked
//                                     ? AppColors.amethyst
//                                     : Colors.transparent,
//                               ),
//                               child: isChecked
//                                   ? const Icon(Icons.check,
//                                       size: 16, color: Colors.white)
//                                   : null,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
