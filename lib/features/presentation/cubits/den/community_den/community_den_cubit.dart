// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:foxxhealth/core/network/api_client.dart';
// import 'package:foxxhealth/core/utils/app_storage.dart';
// import 'package:foxxhealth/features/data/models/community_report_model.dart';
// import 'package:foxxhealth/features/presentation/cubits/community_den/community_den_state.dart';

// class CommunityDenCubit extends Cubit<CommunityDenState> {
//   final ApiClient _apiClient = ApiClient();

//   CommunityDenCubit() : super(CommunityDenInitial());

//   /// Submit a report for a post or comment in the community den
//   Future<void> submitReport({
//     required int postId,
//     required int commentId,
//     required String reportReason,
//     required String additionalDetails,
//   }) async {
//     try {
//       emit(CommunityDenLoading());
      
//       print('🌐 API Call: submitCommunityDenReport');
//       print('📝 Report Details: postId=$postId, commentId=$commentId, reason=$reportReason');
      
//       final requestData = CommunityReportRequest(
//         postId: postId,
//         commentId: commentId,
//         reportReason: reportReason,
//         additionalDetails: additionalDetails,
//       );

//       final response = await _apiClient.post(
//         '/api/v1/community-den/reports',
//         data: requestData.toJson(),
//         options: Options(
//           headers: {
//             'accept': 'application/json',
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${AppStorage.accessToken}',
//           },
//         ),
//       );

//       print('✅ API Response: Community den report submitted successfully');
//       print('📊 Response Status: ${response.statusCode}');
//       print('📊 Response Data: ${response.data}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         emit(CommunityDenSuccess(
//           message: 'Report submitted successfully. Thank you for helping keep our community safe.',
//         ));
//       } else {
//         emit(CommunityDenError(
//           message: 'Failed to submit report. Please try again.',
//         ));
//       }
//     } catch (e) {
//       print('❌ API Error: $e');
//       emit(CommunityDenError(
//         message: 'Failed to submit report: ${e.toString()}',
//       ));
//     }
//   }

//   /// Reset the state to initial
//   void resetState() {
//     emit(CommunityDenInitial());
//   }
// }

