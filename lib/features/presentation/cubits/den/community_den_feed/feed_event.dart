import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeeds extends FeedEvent {}
class RefreshFeeds extends FeedEvent {}
class LoadMoreFeeds extends FeedEvent {}
