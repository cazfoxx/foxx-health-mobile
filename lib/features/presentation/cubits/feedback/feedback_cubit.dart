import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/feedback_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final ApiClient _apiClient = ApiClient();

  FeedbackCubit() : super(FeedbackInitial());

  List<String> selectedFeedback =  [];

  String feedbackText = '';

   void setSelectedFeedback(List<String> selectedItems) {
    selectedFeedback = selectedItems;
    emit(state);
  }

  void setFeedbackText(String feedback){
    feedbackText = feedback;
    emit(state);
  }

  Future<void> createFeedback() async {
    try {
      emit(FeedbackLoading());
       final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId') ?? 0;

      FeedbackModel feedback = FeedbackModel(favoritesCode: selectedFeedback, feedbackText: feedbackText, accountId: accountId);

      final response = await _apiClient.post(
        '/api/v1/feedbacks/',
        data: feedback.toJson(),
      );
      final feedbackResponse = FeedbackModel.fromJson(response.data);
      emit(FeedbackSuccess(feedbackResponse));
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }
} 