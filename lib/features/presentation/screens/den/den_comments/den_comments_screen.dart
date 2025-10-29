// import 'package:flutter/material.dart';
// import 'package:foxxhealth/core/components/foxx_text_field.dart';
// import 'package:foxxhealth/core/components/heart_toggle_button.dart';
// import 'package:foxxhealth/core/utils/app_ui_helper.dart';
// import 'package:foxxhealth/features/presentation/screens/den/pages/report_comment/report_comment_page.dart';
// import 'package:foxxhealth/features/presentation/screens/den/widgets/den_bottom_sheet.dart';
// import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
// import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

// class DenCommentsScreen extends StatelessWidget {
//   const DenCommentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final comments = [
//       {
//         "username": "Maya880",
//         "time": "1w",
//         "comment": "Comments written by username!",
//         "likes": 32,
//         "action": "Delete",
//         "avatar": "https://i.pravatar.cc/150?img=1"
//       },
//       {
//         "username": "Maple\$yrup",
//         "time": "1w",
//         "comment": "Comments written by username!",
//         "likes": 32,
//         "action": "Report",
//         "avatar": "https://i.pravatar.cc/150?img=2"
//       },
//       {
//         "username": "SugarDrop\$",
//         "time": "1w",
//         "comment": "Comments written by username!",
//         "likes": 32,
//         "action": "Report",
//         "avatar": "https://i.pravatar.cc/150?img=3"
//       },
//     ];

//     return DenBottomSheet(
//       header: _buildHeader(context),
//       body: Expanded(
//         child: ListView.separated(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           itemCount: comments.length,
//           separatorBuilder: (_, __) =>
//               const Divider(height: 8, color: Colors.transparent),
//           itemBuilder: (context, index) {
//             final c = comments[index];
//             return _CommentTile(
//               username: c['username']! as String,
//               time: c['time']! as String,
//               comment: c['comment']! as String,
//               likes: c['likes'] as int,
//               action: c['action']! as String,
//               avatarUrl: c['avatar']! as String,
//             );
//           },
//         ),
//       ),
//       footer: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FoxxTextField(
//             focusBorderColor: AppColors.amethyst,
//             minLines: 4,
//             maxLines: 4,
//             suffixIcon: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SizedBox(
//                 child: Container(
//                   height: 100,
//                   // color: Colors.red,
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {},
//                         child: Container(
//                           // height: 24,
//                           width: 24,
//                           decoration: const BoxDecoration(
//                             color: Color(0xffCECECF),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.arrow_upward,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             hint: "Comments",
//             onChanged: (c) {}),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.close, color: Color(0xFF7C4DFF)),
//           ),
//           const Text(
//             "Comments",
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(width: 48), // keeps title centered visually
//         ],
//       ),
//     );
//   }
// }

// class _CommentTile extends StatelessWidget {
//   final String username;
//   final String time;
//   final String comment;
//   final int likes;
//   final String action;
//   final String avatarUrl;

//   const _CommentTile({
//     required this.username,
//     required this.time,
//     required this.comment,
//     required this.likes,
//     required this.action,
//     required this.avatarUrl,
//   });

//   void _handleActionTap(BuildContext context) {
//     if (action.toLowerCase() == 'delete') {
//     } else if (action.toLowerCase() == 'report') {
//       AppHelper.showBottomModalSheet(
//         backgroundColor: Colors.white,
//         context: context,
//         child: const ReportCommentPage(),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Avatar
//           CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatarUrl)),
//           const SizedBox(width: 10),

//           /// Comment Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Username + Time
//                 Row(
//                   children: [
//                     Text(username, style: AppOSTextStyles.osMdBold),
//                     const SizedBox(width: 6),
//                     Text(
//                       time,
//                       style: AppOSTextStyles.osMd.copyWith(
//                         color: AppColors.secondaryTxt,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),

//                 /// Comment Text
//                 Text(
//                   comment,
//                   style:
//                       AppOSTextStyles.osSmSemiboldLabel.copyWith(fontSize: 16),
//                 ),
//                 const SizedBox(height: 6),

//                 /// Likes + Reply + Action
//                 Row(
//                   children: [
//                     HeartToggleButton(
//                       isLiked: false,
//                       onToggle: () async {
//                         await Future.delayed(const Duration(milliseconds: 200));
//                       },
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '$likes',
//                       style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
//                         color: AppColors.secondaryTxt,
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Text(
//                       "Reply",
//                       style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
//                         color: AppColors.secondaryTxt,
//                       ),
//                     ),
//                     const Spacer(),

//                     /// Report or Delete action
//                     GestureDetector(
//                       onTap: () => _handleActionTap(context),
//                       child: Text(
//                         action,
//                         style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
//                           color: AppColors.secondaryTxt,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/components/foxx_text_field.dart';
import 'package:foxxhealth/core/components/heart_toggle_button.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/features/data/models/comments_model.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/report_comment/report_comment_page.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenCommentsScreen extends StatefulWidget {
  final int postId;
  const DenCommentsScreen({super.key, required this.postId});

  @override
  State<DenCommentsScreen> createState() => _DenCommentsScreenState();
}

class _DenCommentsScreenState extends State<DenCommentsScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchComments(widget.postId));
  }

  void _onSendComment(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(
      postId: widget.postId,
      content: text,
      createdAt: DateTime.now(),
      // userProfile: UserProfile(
      //   id: 999,
      //   username: "You",
      //   avatarUrl: "https://i.pravatar.cc/150?img=9",
      // ),
    );

    context.read<CommentBloc>().add(AddComment(newComment));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return DenBottomSheet(
          header: _buildHeader(context),
          body: Expanded(
            child: state.isLoadingComments
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    itemCount: state.comments.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 8, color: Colors.transparent),
                    itemBuilder: (context, index) {
                      final c = state.comments[index];

                      log("comments for mon $c");
                      return _CommentTile(comment: c);
                    },
                  ),
          ),
          footer: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FoxxTextField(
              controller: _textController,
              focusBorderColor: AppColors.amethyst,
              borderColor: AppColors.gray600,

              minLines: 4,
              maxLines: 4,
              hint: "Comment",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Container(
                    height: 100,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: state.isPostingComment
                              ? null
                              : () => _onSendComment(context),
                          child: Container(
                            // height: 24,
                            width: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xffCECECF),
                              shape: BoxShape.circle,
                            ),
                            child: state.isPostingComment
                                ? const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.arrow_upward,
                                    color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child:
              //    GestureDetector(
              //     onTap: state.isPostingComment
              //         ? null
              //         : () => _onSendComment(context),
              //     child: Container(
              //       width: 28,
              //       height: 28,
              //       decoration: const BoxDecoration(
              //         color: Color(0xffCECECF),
              //         shape: BoxShape.circle,
              //       ),
              //       child: state.isPostingComment
              //           ? const Padding(
              //               padding: EdgeInsets.all(4.0),
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2,
              //                 color: Colors.white,
              //               ),
              //             )
              //           : const Icon(Icons.arrow_upward, color: Colors.white),

              //     ),
              //   ),
              // ),
              onChanged: (c) {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Color(0xFF7C4DFF)),
          ),
          const Text(
            "Comments",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({required this.comment});

  void _handleActionTap(BuildContext context) {
    final action =
        (comment.userProfile?.userName == null) ? "Delete" : "Report";
    if (action.toLowerCase() == 'report') {
      AppHelper.showBottomModalSheet(
        backgroundColor: Colors.white,
        context: context,
        child: const ReportCommentPage(),
      );
    } else {
      _onDeleteComment(context, comment.id!);
    }
  }

  void _onDeleteComment(BuildContext context, int commentId) {
    context.read<CommentBloc>().add(DeleteComment(commentId));
  }

  @override
  Widget build(BuildContext context) {
    final username =
        comment.userProfile?.userName ?? UserProfileConstants.getDisplayName();
    final avatar =
        comment.userProfile?.profileIconUrl ?? "https://i.pravatar.cc/150";
    final time = _formatTime(comment.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(username, style: AppOSTextStyles.osMdBold),
                    const SizedBox(width: 6),
                    Text(time,
                        style: AppOSTextStyles.osMd
                            .copyWith(color: AppColors.secondaryTxt)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.content ?? "",
                  style: AppOSTextStyles.osSmSemiboldLabel
                      .copyWith(fontSize: 16, color: AppColors.secondaryTxt),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    HeartToggleButton(
                      isLiked: false,
                      onToggle: () async =>
                          Future.delayed(const Duration(milliseconds: 200)),
                    ),
                    const SizedBox(width: 4),
                    Text('${comment.likesCount ?? 0}',
                        style: AppOSTextStyles.osSmSemiboldLabel
                            .copyWith(color: AppColors.secondaryTxt)),
                    const SizedBox(width: 14),
                    SvgPicture.asset("assets/svg/icons/reply.svg"),
                    const SizedBox(width: 4),
                    Text("Reply",
                        style: AppOSTextStyles.osSmSemiboldLabel
                            .copyWith(color: AppColors.secondaryTxt)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _handleActionTap(context),
                      child: Text(
                        (comment.userProfile?.userName == null)
                            ? "Delete"
                            : "Report",
                        style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                          color: AppColors.secondaryTxt,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "";
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 7) return "${diff.inDays ~/ 7}w";
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    return "${diff.inMinutes}m";
  }
}
