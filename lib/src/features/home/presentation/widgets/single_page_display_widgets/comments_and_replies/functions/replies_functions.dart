import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/features/home/models/material_author.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_related_models/comment_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/comments_functions.dart';

class RepliesFunctions {
  static Future<ContractResponse> uploadNewReply({BaseUploadingModel material, String content, String commentId,MaterialAuthor author})
  async {
    Map<String, dynamic> body = {
      'material_id': material.material_id,
      'material_collection': material.material_collection,
      'comment_collection': material.comments_collection,
      'comment_id': commentId,
      'reply_content': content,

      // this is the author of the comment itself for the sake of handling notifications
      'author_id':author.id,
      'author_one_signal_id':author.oneSignalID,
      'author_notifications_repo':author.notificationsRepo,

    };

    print(body);
    return await HttpMethods.post(body: body, url: Api.UPLOAD_NEW_REPLY);
  }

  static Future<ContractResponse> editReply(
      {BaseUploadingModel material, String content, String replyId, String commentId}) async {
    Map<String, dynamic> body = {
      'comments_collection': material.comments_collection,
      'comment_id': commentId,
      'reply_content': content,
      'reply_id': replyId,

    };

    return await HttpMethods.post(body: body, url: Api.EDIT_REPLY);
  }

  static Future<ContractResponse> deleteReply({BaseUploadingModel material, String replyId,String commentId}) async {
    Map<String, dynamic> body = {
      'comments_collection': material.comments_collection,
      'reply_id': replyId,
      'comment_id': commentId,
    };

    return await HttpMethods.post(body: body, url: Api.DELETE_REPLY);
  }
}
