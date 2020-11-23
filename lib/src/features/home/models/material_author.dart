import 'package:flutter/foundation.dart';

class MaterialAuthor {
  String id;
  String oneSignalID;
  String accountType;
  String notificationsRepo;
  String firstName;
  String lastName;
  String email;
  String profilePictureRef;
  String profileCoverRef;
  String uuid;
  String college;
  String university;
  String section;
  String speciality;
  String school;
  String schoolSection;

  MaterialAuthor({
    @required this.id,
    @required this.uuid,
    @required this.oneSignalID,
    @required this.profilePictureRef,
    @required this.profileCoverRef,
    @required this.notificationsRepo,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.accountType,
    @required this.speciality,
    @required this.section,
    @required this.university,
    @required this.college,
    @required this.schoolSection,
    @required this.school,
  });

  MaterialAuthor.fromJSON(Map<String, dynamic> map)
      : id = map['_id'],
        uuid = map['uuid'],
        oneSignalID = map['one_signal_id'],
        profilePictureRef = map['profile_pic_ref'],
        profileCoverRef = map['profile_cover_ref'],
        notificationsRepo = map['notifications_repo'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        accountType = map['account_type'],
        college = map['college'],
        university = map['university'],
        section = map['section'],
        school = map['school'],
        schoolSection = map['school_section'];

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'uuid': uuid,
        'one_signal_id': oneSignalID,
        'profile_pic_ref': profilePictureRef,
        'profile_cover_ref': profileCoverRef,
        'notifications_repo': notificationsRepo,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'account_type': accountType,
        'university': university,
        'college': college,
        'section': section,
        'school': school,
        'school_section': schoolSection,
      };
}
