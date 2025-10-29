import 'package:equatable/equatable.dart';

abstract class CommunityDenEvent extends Equatable {
  const CommunityDenEvent();

  @override
  List<Object?> get props => [];
}

class FetchCommunityDens extends CommunityDenEvent {}

class SearchCommunityDens extends CommunityDenEvent {
  final String search;
  final int ?skip;
  final int ? limit;
  const SearchCommunityDens({required this.search, this.limit =20, this.skip=0});
}

class ClearSearchCommunityDens extends CommunityDenEvent {}

class FetchCommunityDenDetails extends CommunityDenEvent {
  final int denId;

  const FetchCommunityDenDetails(this.denId);

  @override
  List<Object?> get props => [denId];
}
