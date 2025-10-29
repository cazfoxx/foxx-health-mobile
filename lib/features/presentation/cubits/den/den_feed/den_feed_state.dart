// import 'package:equatable/equatable.dart';
// import 'package:foxxhealth/features/data/models/community_feed_model.dart';

// abstract class DenFeedState extends Equatable {
//   const DenFeedState();

//   @override
//   List<Object?> get props => [];
// }

// class DenFeedInitial extends DenFeedState {}

// class DenFeedLoading extends DenFeedState {}

// class DenFeedLoaded extends DenFeedState {
//   final List<Post> posts;
//   final bool hasMore;
//   const DenFeedLoaded({required this.posts, required this.hasMore});

//   DenFeedLoaded copyWith({
//     List<Post>? posts,
//     bool? hasMore,
//   }) {
//     return DenFeedLoaded(
//       posts: posts ?? this.posts,
//       hasMore: hasMore ?? this.hasMore,
//     );
//   }

//   @override
//   List<Object?> get props => [posts, hasMore];
// }

// class DenFeedError extends DenFeedState {
//   final String message;
//   const DenFeedError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
