import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor/features/chat/enums/user_type_enum.dart';
import 'package:stackfood_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class ChatServiceInterface{
  Future<ConversationsModel?> getConversationList(offset, type);
  bool checkSender(List<Conversation?>? conversations);
  int setIndex(List<Conversation?>? conversations);
  Future<ConversationsModel> searchConversationList(name);
  Future<Response> getMessages(int offset, int? userID, UserType userType, int? conversationID);
  int findOutConversationUnreadIndex(List<Conversation?>? conversations, int? conversationID);
  Future<XFile> compressImage(XFile file);
  List<MultipartBody> processMultipartBody(List<XFile> chatImage);
  Future<MessageModel?> sendMessage(String message, List<MultipartBody> images, NotificationBodyModel? notificationBody, int? conversationID);
}