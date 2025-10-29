import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';

abstract class DenProfilePostState extends Equatable {
  const DenProfilePostState();

  @override
  List<Object?> get props => [];
}

class IntialLoad extends DenProfilePostState {}

class Loading extends DenProfilePostState {}

class Loaded extends DenProfilePostState {
  final FeedModel feed;
  final bool hasMore;
  const Loaded({required this.feed, required this.hasMore});

  Loaded copyWith({
    FeedModel ?feed,
    bool? hasMore,
  }) {
    return Loaded(
      feed: feed ?? this.feed,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [feed, hasMore];
}

class Error extends DenProfilePostState {
  final String message;
  const Error(this.message);

  @override
  List<Object?> get props => [message];
}
