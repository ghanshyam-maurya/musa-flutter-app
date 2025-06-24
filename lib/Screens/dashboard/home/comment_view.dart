// import 'package:just_audio/just_audio.dart';
// import 'package:musa/screens/components/audio_comment_popup.dart';
// import 'package:musa/screens/components/audio_recorder_card.dart';
//
// import '../../../Utility/packages.dart';
// import '../../../cubit/auth_cubit/update_bio_cubit/update_bio_cubit.dart';
// import '../../../cubit/auth_cubit/update_bio_cubit/update_bio_state.dart';
// import '../../../cubit/dashboard_cubit/social_cubit/social_cubit.dart';
// import '../../../imports/resources_import.dart';
// import '../../../resources/musa_widgets.dart';
//
// class CommentView extends StatefulWidget {
//   final String musaId;
//   final bool? keyboardType;
//   final Function(int count) commentCountBtn;
//   const CommentView(
//       {super.key,
//       required this.musaId,
//       required this.keyboardType,
//       required this.commentCountBtn});
//
//   @override
//   State<CommentView> createState() => _CommentViewState();
// }
//
// class _CommentViewState extends State<CommentView> {
//   SocialCubit _socialCubit = SocialCubit();
//
//   late UpdateBioCubit _updateBioCubit;
//   TextEditingController _commentController = TextEditingController();
//
//   @override
//   void initState() {
//     _socialCubit.getCommentApi(musaId: widget.musaId);
//
//     if (widget.keyboardType != false) {
//       _updateBioCubit = context.read<UpdateBioCubit>();
//       _updateBioCubit.initSpeech();
//     }
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }
//
//   bool _isChangingIcon = false;
//   var recogniseText = "Bio (Optional)";
//
//   void _changeIconTemporarily() {
//     setState(() {
//       _isChangingIcon = true;
//       recogniseText = "Recognizing...";
//     });
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         _isChangingIcon = false;
//         _updateBioCubit.stopOnclick();
//         recogniseText = "Bio (Optional)";
//       });
//     });
//   }
//
//   String? audioFilePath;
//
//   onRecordButtonPressed() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             AudioPlayer audioPlayer = AudioPlayer();
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Container(
//                   height: 350,
//                   child: AudioCommentPopup(
//                     onRecordingComplete: (selectedRecordPath) {
//                       print('Recording Complete: $selectedRecordPath');
//                       setState(() {
//                         audioFilePath = selectedRecordPath;
//                       });
//                     },
//                     recordUploadBtn: () {
//                       _socialCubit
//                           .postMusaComment(
//                               musaId: widget.musaId,
//                               musaComment: '',
//                               recordeAudio: audioFilePath.toString())
//                           .then((value) {
//                         int count = _socialCubit.commentCont + 1;
//                         widget.commentCountBtn(count);
//                         setState(() {});
//                       });
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         color: MusaColoStyles.bggrey,
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Container(
//                 height: MediaQuery.of(context).size.height * 5,
//                 padding: EdgeInsets.symmetric(
//                     horizontal: widget.keyboardType == false ? 0 : 16,
//                     vertical: 8),
//                 child: MusaWidgets.commentsList(
//                     context, _socialCubit, widget.keyboardType)),
//             widget.keyboardType == false
//                 ? Container()
//                 : Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       width: double.infinity,
//                       color: MusaColoStyles.white,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 10.w, vertical: 10.h),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Expanded(
//                             child: BlocBuilder<UpdateBioCubit, UpdateBioState>(
//                                 builder: (context, state) {
//                               if (state is UpdateBioListening) {
//                                 _commentController.text = state.recognizedWords;
//                               }
//                               return TextFormField(
//                                 controller: _commentController,
//                                 decoration: InputDecoration(
//                                   hintText: 'Type Comment',
//                                   hintStyle: MusaTextStyle.normalTextStyle
//                                       .copyWith(color: Colors.grey),
//                                   filled: true,
//                                   fillColor: MusaColoStyles.white,
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 15.w,
//                                     vertical: 10.h,
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                           SizedBox(width: 15.w),
//                           GestureDetector(
//                             onTap: () {
//                               onRecordButtonPressed();
//                             },
//                             child: CircleAvatar(
//                               radius: 15,
//                               backgroundColor: Colors.green,
//                               child: Icon(
//                                 Icons.record_voice_over_sharp,
//                                 color: Colors.white,
//                                 size: 15,
//                               ),
//                             ),
//                           ),
//                           // InkWell(onTap: () {
//                           //   setState(() {
//                           //     _updateBioCubit.startListening();
//                           //     _changeIconTemporarily();
//                           //   });
//                           // }, child: BlocBuilder<UpdateBioCubit, UpdateBioState>(
//                           //   builder: (context, state) {
//                           //     if (_isChangingIcon) {
//                           //       return CircleAvatar(
//                           //         radius: 20,
//                           //         backgroundColor: Colors.green,
//                           //         child: Icon(
//                           //           Icons.record_voice_over_outlined,
//                           //           color: Colors.white,
//                           //         ),
//                           //       );
//                           //     } else {
//                           //       return Icon(Icons.mic_none,
//                           //           color: MusaColoStyles.primaryColor,
//                           //           size: 30.sp);
//                           //     }
//                           //   },
//                           // )),
//                           InkWell(
//                             onTap: () {
//                               if (_commentController.text.trim().isNotEmpty) {
//                                 _socialCubit
//                                     .postMusaComment(
//                                         musaId: widget.musaId,
//                                         musaComment: _commentController.text)
//                                     .then((value) {
//                                   int count = _socialCubit.commentCont + 1;
//                                   widget.commentCountBtn(count);
//                                   setState(() {});
//                                 });
//
//                                 FocusScope.of(context).unfocus();
//                                 _commentController.clear();
//                                 _updateBioCubit.clearRecognizedText();
//                               }
//                             },
//                             child: Icon(Icons.send,
//                                 color: MusaColoStyles.primaryColor,
//                                 size: 30.sp),
//                           ),
//                         ],
//                       ),
//                     )),
//           ],
//         ),
//       ),
//     );
//   }
// }
