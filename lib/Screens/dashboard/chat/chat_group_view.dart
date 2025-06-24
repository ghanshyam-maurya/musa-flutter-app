import 'dart:async';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musa_app/Cubit/dashboard/Chat/chat_list_cubit.dart';
import 'package:musa_app/Cubit/dashboard/Chat/chat_list_state.dart';
import 'package:musa_app/Repository/AppResponse/chat_modals/chat_list_response.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../Repository/AppResponse/Responses/logged_in_response.dart';

class ChatView extends StatefulWidget {
  ChatListData chatListData;
  ChatView({super.key, required this.chatListData});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatListCubit cubit = ChatListCubit();
  User userData = User();

  // final List<Map<String, dynamic>> messages = [];
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final record = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _audioFilePath;
  final Duration _audioDuration = Duration.zero;
  final Duration _audioPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  int? _currentPlayingIndex;

  /// Dev Socket Url
  // final String serverUrl = 'http://54.235.51.33:3000/';
  // final String serverUrl = 'https://9a0b-59-162-82-6.ngrok-free.app';

  /// Stagging Socket Url
  final String serverUrl = 'http://54.209.163.97:3000/';

  IO.Socket? socket;

  final ScrollController _scrollController = ScrollController();

  connectToSocket() {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    try {
      socket?.connect();
    } catch (e) {
      print('Error : $e');
    }

    socket?.onConnect((_) {
      print('Connected to the socket server');
      // socket?.emit('sendMessage', ['675f2e34cbfc9ac70d8461d4' ,'675f2e34cbfc9ac70d8461d4' ,null,'Hello Asif.....']);
    });

    socket?.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    socket?.onError((error) => print('Socket Error: $error'));

    socket?.on('sendMessage', (data) {
      cubit.updateMessages(
          Message(
              senderId: data[0],
              receiverId: data[1],
              groupId: data[2],
              text: data[3],
              timeStamp: data[4]),
          receivedId: widget.chatListData.userDetail!.id!,
          senderId: userData.id.toString(),
          comingReceivedId: data[1],
          comingSenderId: data[0],
          fromApi: false);
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    });
  }

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    // _initializeRecorder();
    _scrollController.addListener(_loadMore);
    userData = Utilities.getUserData();
    cubit.getChatData(
        groupId: widget.chatListData.id,
        senderId: widget.chatListData.senderId,
        receiverId:
            widget.chatListData.receiverId //widget.chatListData.userDetail!.id,
        // chatType: widget.chatListData.chatType
        );
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {});
        _audioPlayer.stop();
      }
    });
    connectToSocket();
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // cubit.getChatData(nextUrl: cubit.chatHistoryResponse.nextPageUrl);
    }
  }

  // Function to send a message to the server.
  sendMessage(
      {String? senderId,
      String? receiverId,
      String? groupId,
      String? chatType,
      DateTime? timeStamp}) {
    String message = cubit.messageController.text.trim();
    // print(
    //     "{senderId : $senderId, receiverId : $receiverId, groupId : $groupId, message : $message, timeStamp : $timeStamp}");
    if (message.isNotEmpty) {
      try {
        socket?.emit('sendMessage', [senderId, receiverId, groupId, message]);
      } catch (e) {
        print("Error in Chat : $e");
      }

      cubit.clearController();
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    socket?.disconnect();
    socket?.dispose();
    _recorder.closeRecorder();
    super.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();

      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      final config = RecordConfig(encoder: AudioEncoder.aacLc);

      await record.start(config, path: filePath);
      setState(() {
        _isRecording = true;
        _audioFilePath = filePath;
      });
      // _startTimer();
    }
  }

  Future<void> stopRecording() async {
    try {
      final filePath = await record.stop();
      setState(() {
        _isRecording = false;
      });
      if (filePath != null) {
        String senderId = userData.id!;
        String receiverId = widget.chatListData.userDetail?.id ?? "";
        cubit.postMediaFileApi(
            senderId: senderId,
            receiverId: receiverId,
            message: _audioFilePath.toString());
      } else {
        print("Recording file path is null.");
      }
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Widget _senderMessageBubble(
      {required String message,
      required String messageType,
      required DateTime timeStamp,
      required int index}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
              alignment: Alignment.centerRight,
              backGroundColor: AppColor.splashColor,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: message.contains("musadevtest")
                    ? Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _audioPlayer.playing &&
                                      _currentPlayingIndex == index
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_audioPlayer.playing &&
                                    _currentPlayingIndex == index) {
                                  _audioPlayer.pause();
                                } else {
                                  _playAudio(
                                      filePath: message,
                                      messageId: index.toString());
                                }
                              });
                            },
                          ),
                          Text(
                            _formatDuration(_audioPosition),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          Expanded(
                            child: Slider(
                              value: _audioPosition.inMilliseconds.toDouble(),
                              max: _audioDuration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                _audioPlayer.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          Text(
                            _formatDuration(_audioDuration),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    : Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, right: 8.0),
              child: Text(
                DateFormat.jm().format(cubit.getConvertdTime(timeStamp)),
                style: AppTextStyle.normalTextStyle1.copyWith(
                  fontSize: 10,
                  color: const Color(0xff979797),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Map<String, AudioPlayer> _audioPlayers = {};
  final Map<String, Duration> _audioPositions = {};
  String? _currentlyPlayingId;

  Future<void> _playAudio(
      {required String messageId, required String filePath}) async {
    try {
      if (_currentlyPlayingId != null && _currentlyPlayingId != messageId) {
        _audioPlayers[_currentlyPlayingId]?.stop();
      }
      if (!_audioPlayers.containsKey(messageId)) {
        _audioPlayers[messageId] = AudioPlayer();
      }
      AudioPlayer player = _audioPlayers[messageId]!;
      if (filePath.startsWith("http")) {
        await player.setUrl(filePath);
      } else {
        await player.setFilePath(filePath);
      }

      // Update position and duration streams
      player.positionStream.listen((position) {
        setState(() {
          _audioPositions[messageId] = position;
        });
      });

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _currentlyPlayingId = null;
          });
          player.stop();
        }
      });

      // Play the audio
      setState(() {
        _currentlyPlayingId = messageId;
      });
      await player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _pauseAudio(String messageId) {
    if (_audioPlayers.containsKey(messageId)) {
      _audioPlayers[messageId]?.pause();
    }
  }

  void _stopAudio(String messageId) {
    if (_audioPlayers.containsKey(messageId)) {
      _audioPlayers[messageId]?.stop();
      _audioPlayers.remove(messageId);
      setState(() {
        if (_currentlyPlayingId == messageId) _currentlyPlayingId = null;
      });
    }
  }

  // Future<void> _playAudio(String filePath) async {
  //   try {
  //     if (filePath.startsWith("http")) {
  //       await _audioPlayer.setUrl(filePath);
  //       _positionSubscription = _audioPlayer.positionStream.listen((position) {
  //         setState(() {
  //           _audioPosition = position;
  //         });
  //       });
  //
  //       _audioPlayer.durationStream.listen((duration) {
  //         setState(() {
  //           _audioDuration = duration ?? Duration.zero;
  //         });
  //       });
  //     } else {
  //       await _audioPlayer.setFilePath(filePath);
  //       _positionSubscription = _audioPlayer.positionStream.listen((position) {
  //         setState(() {
  //           _audioPosition = position;
  //         });
  //       });
  //
  //       _audioPlayer.durationStream.listen((duration) {
  //         setState(() {
  //           _audioDuration = duration ?? Duration.zero;
  //         });
  //       });
  //     }
  //     _audioPlayer.play();
  //     setState(() {});
  //   } catch (e) {
  //     print("Error playing audio: $e");
  //   }
  // }

  Widget _receiverMessageBubble(
      {required String message,
      required String messageType,
      required DateTime timeStamp,
      required int index}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper2(type: BubbleType.receiverBubble),
              alignment: Alignment.centerLeft,
              backGroundColor: AppColor.greyChatBG,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: message.contains("musadevtest")
                    ? Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _audioPlayer.playing &&
                                      _currentPlayingIndex == index
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_audioPlayer.playing &&
                                    _currentPlayingIndex == index) {
                                  _audioPlayer.pause();
                                } else {
                                  _playAudio(
                                      filePath: message,
                                      messageId: index.toString());
                                }
                              });
                            },
                          ),
                          Text(
                            _formatDuration(_audioPosition),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          Expanded(
                            child: Slider(
                              value: _audioPosition.inMilliseconds.toDouble(),
                              max: _audioDuration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                _audioPlayer.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          Text(
                            _formatDuration(_audioDuration),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    : Text(
                        message,
                        style: const TextStyle(color: Colors.black),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, right: 8.0, left: 8.0),
              child: Text(
                  DateFormat.jm().format(cubit.getConvertdTime(timeStamp)),
                  style: AppTextStyle.normalTextStyle1
                      .copyWith(fontSize: 10, color: Color(0xff979797))),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListCubit, ChatListState>(
        bloc: cubit,
        listener: (context, state) {
          // if(state is ChatDeleted){
          //   BMGWidgets.successPopUp(context: context, title: 'Chat Deleted Successfully', imageUrl: Assets.successIcon);
          //   Future.delayed(const Duration(seconds: 1), () {
          //     context.pop();
          //     context.pop(true);
          //     context.pop(true);
          //   });
          // }
          // if (state is ChatListError) {
          //   if (state.errorMessage != null) {
          //     BMGWidgets.popUpDialouge(
          //         context: context,
          //         onPressed: () => context.pop(true),
          //         buttonText: StringConst.okay,
          //         title: StringConst.error,
          //         description: state.errorMessage);
          //   } else {
          //     //on 404
          //     BMGWidgets.popUpDialouge(
          //         context: context,
          //         onPressed: () => context.pop(true),
          //         buttonText: StringConst.okay,
          //         title: StringConst.error,
          //         description: StringConst.internalError);
          //   }
          // }
        },
        builder: (context, state) {
          return Scaffold(
            body: (state is ChatListLoading) ||
                    cubit.chatHistoryResponse.data == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      MusaWidgets.commonAppBar(
                        height: 130.sp,
                        row: Padding(
                          padding: MusaPadding.appBarPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.pop(true);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 25,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      StringConst.profileValue = "HomeUser";
                                      String UserId =
                                          widget.chatListData.userDetail?.id ??
                                              "0";

                                      context.push(RouteTo.myProfile
                                          .replaceFirst(':UserId', UserId));
                                    },
                                    child: MusaWidgets.userProfileAvatar(
                                      imageUrl:
                                          widget.chatListData.userDetail?.photo,
                                      radius: 25.sp,
                                      borderWidth: 2.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.sp),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.chatListData.userDetail?.firstName} ${widget.chatListData.userDetail?.lastName}',
                                        style: AppTextStyle.appBarTitleStyle,
                                      ),
                                      Text(
                                        "Last seen 20 min ago",
                                        style: AppTextStyle.normalTextStyle1
                                            .copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(Icons.more_vert,
                                  color: AppColor.black, size: 25.sp),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: cubit.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return cubit.messages[index].senderId == userData.id
                                ? _senderMessageBubble(
                                    message:
                                        cubit.messages[index].text.toString(),
                                    messageType: cubit
                                        .messages[index].messageType
                                        .toString(),
                                    timeStamp: DateTime.parse(cubit
                                        .messages[index].timeStamp
                                        .toString()),
                                    index: index,
                                  )
                                : _receiverMessageBubble(
                                    message:
                                        cubit.messages[index].text.toString(),
                                    messageType: cubit
                                        .messages[index].messageType
                                        .toString(),
                                    timeStamp: DateTime.parse(cubit
                                        .messages[index].timeStamp
                                        .toString()),
                                    index: index,
                                  );
                          },
                        ),
                      ),
                      Card(
                        elevation: 0.7,
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  Timer(
                                      Duration(milliseconds: 300),
                                      () => _scrollController.jumpTo(
                                          _scrollController
                                              .position.maxScrollExtent));
                                },
                                child: CommonDropdownWidgets.textFieldChat(
                                  inputMaxLine: 1,
                                  inputMinLine: 1,
                                  inputHintText: 'Type messgae here.....',
                                  inputController: cubit.messageController,
                                  onFieldSubmitted: (value) {
                                    sendMessage(
                                        senderId: userData.id,
                                        receiverId:
                                            widget.chatListData.userDetail?.id,
                                        groupId: widget.chatListData.id,
                                        timeStamp: DateTime.now());
                                  },
                                ),
                              )),
                              IconButton(
                                  icon: Icon(
                                    _isRecording ? Icons.stop : Icons.mic_none,
                                    color: AppColor.splashColor,
                                  ),
                                  // onPressed: _isRecording
                                  //     ? startRecording
                                  //     : stopRecording,
                                  onPressed: () {
                                    if (_isRecording) {
                                      stopRecording();
                                    } else {
                                      startRecording();
                                    }
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: AppColor.splashColor,
                                  ),
                                  onPressed: () => sendMessage(
                                      senderId: userData.id,
                                      receiverId:
                                          widget.chatListData.userDetail?.id,
                                      groupId: widget.chatListData.id,
                                      timeStamp: DateTime.now())),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}

class Message {
  final String? text;
  final String? messageType;
  final String? senderId;
  final String? receiverId;
  final String? groupId;
  final String? timeStamp;

  const Message(
      {this.text,
      this.messageType,
      this.senderId,
      this.receiverId,
      this.groupId,
      this.timeStamp});
}
