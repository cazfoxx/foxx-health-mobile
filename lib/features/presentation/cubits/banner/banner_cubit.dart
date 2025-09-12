import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/banner_model.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final ApiClient _apiClient = ApiClient();

  BannerCubit() : super(BannerInitial());

  // Service functions moved from BannerService
  Future<BannerResponse> getBanners() async {
    try {
      emit(BannerLoading());
      
      final response = await _apiClient.get('/api/v1/home/banner/me');
      
      if (response.statusCode == 200) {
        final result = BannerResponse.fromJson(response.data);
        emit(BannerLoaded(result));
        return result;
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      emit(BannerError(e.toString()));
      throw Exception('Error fetching banners: $e');
    }
  }
}



