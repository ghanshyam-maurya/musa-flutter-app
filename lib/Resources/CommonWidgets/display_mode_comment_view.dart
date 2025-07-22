import 'package:musa_app/Cubit/Comment/comment_cubit.dart';
import 'package:musa_app/Cubit/Comment/comment_state.dart';
import 'package:musa_app/Resources/CommonWidgets/audio_recoder.dart';
import 'package:musa_app/Resources/component/comment_audio_player.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dotted_border/dotted_border.dart';

class DisplayModeCommentView extends StatefulWidget {
  final String musaId;
  final Function(int count) commentCountBtn;

  const DisplayModeCommentView({
    super.key,
    required this.musaId,
    required this.commentCountBtn,
  });

  @override
  State<DisplayModeCommentView> createState() => _DisplayModeCommentViewState();
}

class _DisplayModeCommentViewState extends State<DisplayModeCommentView> {
  CommentCubit cubit = CommentCubit();
  TextEditingController commentController = TextEditingController();
  String? audioFilePath;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("📣 DisplayModeCommentView initialized");
    cubit.getCommentApi(musaId: widget.musaId);
  }

  @override
  void dispose() {
    commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Column(
          children: [
            //const Spacer(),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        BlocBuilder<CommentCubit, CommentState>(
                          bloc: cubit,
                          builder: (context, state) {
                            int count = cubit.commentList.length;
                            return Text(
                              "$count comment${count == 1 ? '' : 's'}",
                              style: AppTextStyle.normalBoldTextStyle
                                  .copyWith(fontSize: 14),
                            );
                          },
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.close,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: const Color(0xFFE9E9E9),
                    thickness: 1,
                    height: 1,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: BlocBuilder<CommentCubit, CommentState>(
                      bloc: cubit,
                      builder: (context, state) {
                        if (state is CommentLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          );
                        } else if (state is CommentSuccess &&
                            cubit.commentList.isNotEmpty) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: cubit.commentList.length,
                            itemBuilder: (context, index) {
                              final item = cubit.commentList[index];
                              final user = item.userDetail?.first;
                              final name =
                                  "${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                                      .trim();
                              final avatar = user?.photo ?? '';
                              final time = item.createdAt != null
                                  ? timeago
                                      .format(DateTime.parse(item.createdAt!))
                                  : '';
                              final isAudio = item.fileLink != null;

                              return DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(0),
                                color: const Color(0xFFE9E9E9),
                                dashPattern: const [4, 4],
                                strokeWidth: 1,
                                customPath: (size) => Path()
                                  ..moveTo(0, size.height)
                                  ..lineTo(size.width, size.height),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 16, right: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MusaWidgets.userProfileAvatar(
                                            imageUrl: avatar,
                                            radius: 20.sp,
                                            borderWidth: 2.sp,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: AppTextStyle
                                                      .normalBoldTextStyle
                                                      .copyWith(fontSize: 14),
                                                ),
                                                const SizedBox(height: 4),
                                                isAudio
                                                    ? CommentAudioPlayer(
                                                        fileLink:
                                                            item.fileLink!,
                                                      )
                                                    : Text(
                                                        item.text ?? '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text("No comments available"));
                        }
                      },
                    ),
                  ),
                  //_buildCommentInputField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
