import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor/features/chat/enums/user_type_enum.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/connect.dart';

class ChatRepository implements ChatRepositoryInterface {
  final ApiClient apiClient;
  ChatRepository({required this.apiClient});

  @override
  Future<ConversationsModel?> getConversationList(int offset, String type) async {
    ConversationsModel? conversationModel;
    Response response = await apiClient.getData('${AppConstants.conversationListUri}?limit=10&offset=$offset&type=$type');
    if(response.statusCode == 200){
      conversationModel = ConversationsModel.fromJson(response.body);
    }
    return conversationModel;
  }

  @override
  Future<ConversationsModel> searchConversationList(String name) async {
    ConversationsModel searchConversationModel = ConversationsModel();
    Response response = await apiClient.getData('${AppConstants.searchConversationListUri}?name=$name&limit=20&offset=1');
    if(response.statusCode == 200) {
      searchConversationModel = ConversationsModel.fromJson(response.body);
    }
    return searchConversationModel;
  }

  ///Get the messages ..
  @override
  Future<Response> get(String? userID, {int? offset, UserType? userType, int? conversationID}) async {
    return await apiClient.getData('${AppConstants.messageListUri}?${conversationID != null ? 'conversation_id' :userType == UserType.admin ? 'admin_id'
        : userType == UserType.vendor ? 'vendor_id' : 'delivery_man_id'}=${conversationID ?? userID}&offset=$offset&limit=10');
  }

  @override
  Future<MessageModel?> sendMessage(String message, List<MultipartBody> images, int? userID, UserType userType, int? conversationID) async {
    MessageModel? messageModel;
    Map<String, String> fields = {};
    fields.addAll({'message': message, 'receiver_type': userType.name, 'offset': '1', 'limit': '10'});
    if(conversationID != null) {
      fields.addAll({'conversation_id': conversationID.toString()});
    } else {
      fields.addAll({'receiver_id': userID.toString()});
    }
    Response response = await apiClient.postMultipartData(AppConstants.sendMessageUri, fields, images, []);
    if(response.statusCode == 200) {
      messageModel = MessageModel.fromJson(response.body);
    }
    return messageModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}