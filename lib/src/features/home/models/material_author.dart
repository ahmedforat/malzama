import 'package:flutter/foundation.dart';

class MaterialAuthor {
  String id;
  String oneSignalID;
  String profilePictureRef;
  String profileCoverRef;
  String notificationsRepo;
  String firstName;
  String lastName;
  String accountType;

  MaterialAuthor({
    @required this.id,
    @required this.oneSignalID,
    @required this.profilePictureRef,
    @required this.profileCoverRef,
    @required this.notificationsRepo,
    @required this.firstName,
    @required this.lastName,
    @required this.accountType,
  });

  MaterialAuthor.fromJSON(Map<String, dynamic> map)
      : id = map['_id'],
        oneSignalID = map['one_signal_id'],
        profilePictureRef = map['profile_pic_ref'],
        profileCoverRef = map['profile_cover_ref'],
        notificationsRepo = map['notifications_repo'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        accountType = map['account_type'];

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'one_signal_id': oneSignalID,
        'profile_pic_ref': profilePictureRef,
        'profile_cover_ref': profileCoverRef,
        'notifications_repo': notificationsRepo,
        'firstName': firstName,
        'lastName': lastName,
        'account_type': accountType,
      };
}
