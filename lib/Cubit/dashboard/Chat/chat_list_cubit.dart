import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:musa_app/Cubit/dashboard/Chat/chat_list_state.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Repository/AppResponse/chat_modals/chat_history_response.dart';
import 'package:musa_app/Repository/AppResponse/chat_modals/chat_list_response.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:musa_app/Screens/dashboard/chat/chat_group_view.dart';
import 'package:musa_app/Utility/packages.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());

  final ApiClient _apiClient = ApiClient();
  Repository repository = Repository();
  ChatListResponse chatListResponse = ChatListResponse();
  ChatHistoryResponse chatHistoryResponse = ChatHistoryResponse();
  bool accept = false;

  //For Chat History Data
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  init() {
    getChatGroupListData();
  }

  updateMessages(Message message,
      {String? comingReceivedId,
      String? comingSenderId,
      String? receivedId,
      String? senderId,
      bool fromApi = false}) {
    emit(ChatListInitial());
    // print("comingReceivedId : $comingReceivedId,comingSenderId : $comingSenderId, receivedId : $receivedId, senderId : $senderId, fromApi : $fromApi");
    if (fromApi) {
      messages.add(message);
      emit(ChatListFetched());
    } else {
      if (senderId == comingReceivedId && receivedId == comingSenderId) {
        messages.add(message);
      } else if (senderId == comingSenderId && receivedId == comingReceivedId) {
        messages.add(message);
      } else {
        print("Error : Id's are not matching");
      }
    }
    print("messages Count: ${messages.length}");
    emit(ChatListSelected());
  }

  clearController() {
    emit(ChatListInitial());
    messageController.clear();
    emit(ChatListSelected());
  }

  getConvertdTime(DateTime timeStamp) {
    var dateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse((timeStamp.toString()), true);
    var dateLocal = dateTime.toLocal();
    return dateLocal;
  }

  onBackPressedNew({required BuildContext context}) {
    context.pop(true);
  }

  Future<void> getChatGroupListData() async {
    final token = Prefs.getString(PrefKeys.token);
    emit(ChatListLoading());
    try {
      final response = await _apiClient.get(
        ApiUrl.getGroupList,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response['status'] == 200) {
        chatListResponse = ChatListResponse.fromJson(response);
        emit(ChatListFetched());
      } else {
        emit(ChatListError(errorMessage: response['message']));
      }
    } catch (e) {
      print("Error : $e");
      emit(ChatListError(errorMessage: "An error occurred: $e"));
    }
  }

  Future<void> postMediaFileApi({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final token = Prefs.getString(PrefKeys.token);
    try {
      var headers = {'Authorization': "Bearer $token"};
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.chatsSend));
      request.fields.addAll({'senderId': senderId, 'receiverId': receiverId});
      request.files.add(await http.MultipartFile.fromPath('message', message));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      if (responseBody.statusCode == 200) {
        var dataValue = jsonDecode(responseBody.body);
        updateMessages(
          Message(
            senderId: dataValue['data']['senderId'],
            receiverId: dataValue['data']['receiverId'],
            groupId: dataValue['data']['groupChatID'],
            text: dataValue['data']['message'],
            timeStamp: dataValue['data']['created_at'],
            messageType: dataValue['data']['message_type'],
          ),
        );
        emit(ChatMediaSuccess());
      } else {
        emit(ChatListError(errorMessage: responseBody.body));
      }
    } catch (e) {
      print("Error : $e");
      emit(ChatListError(errorMessage: "An error occurred: $e"));
    }
  }

  Future<void> getChatData(
      {String? groupId,
      String? senderId,
      String? receiverId,
      String? chatType}) async {
    final token = Prefs.getString(PrefKeys.token);
    emit(ChatListInitial());
    try {
      emit(ChatListLoading());
      final response = await _apiClient.post(ApiUrl.chatHistory, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        "senderId": senderId,
        "receiverId": receiverId,
        "groupChatId": '$groupId'
      });
      if (response['status'] == 200) {
        chatHistoryResponse = ChatHistoryResponse.fromJson(response);
        for (int i = 0; i < chatHistoryResponse.data!.length; i++) {
          updateMessages(
              Message(
                  text: chatHistoryResponse.data?[i].message.toString(),
                  senderId: chatHistoryResponse.data![i].senderId.toString(),
                  receiverId: chatHistoryResponse.data![i].receiverId,
                  groupId: chatHistoryResponse.data![i].id.toString(),
                  timeStamp: chatHistoryResponse.data?[i].createdAt.toString(),
                  messageType: 'text'),
              fromApi: true);
        }
        emit(ChatListFetched());
      } else {
        emit(ChatListError(errorMessage: response['message']));
      }
    } catch (e) {
      emit(ChatListError(errorMessage: "An error occurred: $e"));
    }
  }
}
