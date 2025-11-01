import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/components/foxx_text_field.dart';
import 'package:foxxhealth/core/components/heart_toggle_button.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/core/utils/image_util.dart';
import 'package:foxxhealth/features/data/models/comments_model.dart';
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
  final _scrollController = ScrollController(); // ✅ Step 1

  int _lastCommentCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchComments(widget.postId));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose(); // ✅ Dispose controller
    super.dispose();
  }

  void _onSendComment(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(
      postId: widget.postId,
      content: text,
      createdAt: DateTime.now(),
    );
    context.read<CommentBloc>().add(AddComment(newComment));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>( // ✅ Use BlocConsumer
      listener: (context, state) {
        // ✅ Step 3: Scroll when new comment is added
        if (state.comments.length > _lastCommentCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
        _lastCommentCount = state.comments.length;
      },
      builder: (context, state) {
           return DenBottomSheet(
          header: _buildHeader(context),
          body: Expanded(
            child: state.isLoadingComments
                ? const Center(
                    child: SizedBox(child: CircularProgressIndicator()))
                : ListView.separated(
                  controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    itemCount: state.comments.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 8, color: Colors.transparent),
                    itemBuilder: (context, index) {
                      final c = state.comments[index];
                      return _CommentTile(comment: c);
                    },
                  ),
          ),
          footer: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.error != null)
                  Text(
                    "${state.error}",
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                FoxxTextField(
                  controller: _textController,
                  focusBorderColor: AppColors.amethyst,
                  borderColor: AppColors.gray600,

                  minLines: 4,
                  maxLines: 4,
                  hint: "Comment",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: state.isPostingComment
                                  ? null
                                  : () => _onSendComment(context),
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xffCECECF),
                                  shape: BoxShape.circle,
                                ),
                                child: state.isPostingComment
                                    ? const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
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
              ],
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
      _onDeleteComment(context);
    }
  }

  void _onDeleteComment(
    BuildContext context,
  ) {
    context.read<CommentBloc>().add(DeleteComment(
          comment: comment,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final username =
        comment.userProfile?.userName ?? UserProfileConstants.getDisplayName();
    final avatar =
        comment.userProfile?.profileIconUrl;
    final time = _formatTime(comment.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, child: ImageUtil.getUserImage(avatar),),
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
