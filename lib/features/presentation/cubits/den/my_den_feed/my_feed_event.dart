import 'package:equatable/equatable.dart';

abstract class MyFeedEvent extends Equatable {
  const MyFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyFeeds extends MyFeedEvent {}
class RefreshMyFeeds extends MyFeedEvent {}
class LoadMoreFeeds extends MyFeedEvent {}

