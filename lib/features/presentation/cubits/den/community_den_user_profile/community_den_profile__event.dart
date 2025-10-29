abstract class DenProfileEvent {}

class LoadPosts extends DenProfileEvent {
  final String userName;
  LoadPosts({required this.userName});
}

class LoadMorePosts extends DenProfileEvent {
  final String userName;
  LoadMorePosts({required this.userName});
}

class RefeshPosts extends DenProfileEvent {
  final String userName;
  RefeshPosts({required this.userName});
}
