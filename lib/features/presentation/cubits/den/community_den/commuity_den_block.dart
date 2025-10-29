import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den/community_den_event.dart';
import 'community_den_state.dart';

class CommunityDenBloc extends Bloc<CommunityDenEvent, CommunityDenState> {
  final CommunityDenRepository repository;
  List<CommunityDenModel> _originalDens = []; // cache

  CommunityDenBloc(this.repository) : super(CommunityDenInitial()) {
    on<FetchCommunityDens>(_onFetchCommunityDens);
    on<SearchCommunityDens>(_onSearchCommunityDens);
    on<ClearSearchCommunityDens>(_onClearSearchCommunityDens);
  }

  Future<void> _onFetchCommunityDens(
    FetchCommunityDens event,
    Emitter<CommunityDenState> emit,
  ) async {
    emit(CommunityDenLoading());
    try {
      final dens = await repository.getCommunityDens();
      _originalDens = dens;
      emit(CommunityDenLoaded(dens));
    } catch (e) {
      emit(CommunityDenError(e.toString()));
    }
  }

  Future<void> _onSearchCommunityDens(
    SearchCommunityDens event,
    Emitter<CommunityDenState> emit,
  ) async {
    if (event.search.trim().isEmpty) {
      emit(CommunityDenLoaded(_originalDens)); // just restore
      return;
    }

    emit(CommunityDenLoading());
    try {
      final dens = await repository.searchDens(search:  event.search);
      emit(CommunityDenLoaded(dens));
    } catch (e) {
      emit(CommunityDenError(e.toString()));
    }
  }

  void _onClearSearchCommunityDens(
    ClearSearchCommunityDens event,
    Emitter<CommunityDenState> emit,
  ) {
    emit(CommunityDenLoaded(_originalDens)); // instantly restore
  }
}
