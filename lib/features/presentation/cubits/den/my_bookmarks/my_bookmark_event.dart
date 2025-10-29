import 'package:equatable/equatable.dart';

abstract class MyBookmarkEvent extends Equatable {
  const MyBookmarkEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookmark extends MyBookmarkEvent {}
class RefreshBookmark extends MyBookmarkEvent {}
class LoadMoreBookmark extends MyBookmarkEvent {}
