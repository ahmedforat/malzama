import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

import '../material_author.dart';

class StudyMaterial {
  String id;
  String title;
  String description;
  String topic;
  String postDate;
  String lastUpdate;
  MaterialAuthor author;
  String materialCollection;
  String materialType;
  List<String> comments;
  String commentsCollection;
  int stage;
  int size;
  String src;
  String localPath;
  bool isSaved;

  StudyMaterial(
      {this.id,
      this.title,
      this.description,
      this.topic,
      this.postDate,
      this.lastUpdate,
      this.author,
      this.materialCollection,
      this.materialType,
      this.comments,
      this.commentsCollection,
      this.stage,
      this.size,
      this.src,
      this.localPath}) {
    isSaved = _getIsSavedValue();
  }

  bool _getIsSavedValue() {
    User userData = locator<UserInfoStateProvider>().userData;
    if (this.size != null) {
      return userData.savedLectures.contains(this.id);
    }
    if (this.src != null) {
      return userData.savedVideos.contains(this.id);
    }
    return userData.savedQuizes.contains(this.id);
  }

  StudyMaterial.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        description = json['description'],
        topic = json['topic'],
        postDate = json['post_date'],
        lastUpdate = json['last_update'],
        author = MaterialAuthor.fromJSON(json['author']),
        materialCollection = json['material_collection'],
        materialType = json['material_type'],
        comments = List<String>.from(json['comments']),
        commentsCollection = json['comments_collection'],
        stage = int.parse(json['stage'].toString()),
        size = int.parse(json['size']?.toString() ?? '0'),
        src = json['src'],
        localPath = json['localPath'] {
    isSaved = _getIsSavedValue();
  }

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'title': title,
        'description': description,
        'topic': topic,
        'post_date': postDate,
        'last_update': lastUpdate,
        'author': author,
        'material_collection': materialCollection,
        'material_type': materialType,
        'comments': comments,
        'comments_collection': commentsCollection,
        'stage': stage,
        'size': size,
        'src': src,
        'localPath': localPath,
      };

  Map<String, String> get newCommentData => {
        'material_collection': materialCollection,
        'material_id': id,
        'material_type': materialType,
        'comments_collection': commentsCollection,
        'author_id': author.id,
        'author_one_signal_id': author.oneSignalID,
        'author_notifications_repo': author.notificationsRepo,
      };

  String get commentRatingQueryString {
    return '?commentsCollection=$commentsCollection'
        '&authorId=${author.id}'
        '&authorOneSignalId=${author.oneSignalID}'
        '&authorNotificationsRepo=${author.notificationsRepo}'
        '&materialId=$id'
        '&materialCollection=$materialCollection}';
  }

  Map<String, String> get newReplyData => newCommentData..remove('material_type');

  String get commentDeletionQueryString {
    return '?materialCollection=$materialCollection&materialId=$id&commentsCollection=$commentsCollection';
  }
}
