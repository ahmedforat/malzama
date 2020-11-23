import './user.dart';

class SchoolUser extends User {
  String school;
  String schoolSection;
  String subRegion;

  SchoolUser({
    this.school,
    this.schoolSection,
    this.subRegion,
    String id,
    String oneSignalId,
    String accountType,
    String notificationsRepo,
    String firstName,
    String lastName,
    String email,
    String profilePicture,
    String coverPicture,
    String gender,
    String bio,
    String province,
    List<String> savedLectures,
    List<String> savedVideos,
    List<String> savedQuizes,
  }) : super(
          id: id,
          oneSignalId: oneSignalId,
          accountType: accountType,
          notificationsRepo: notificationsRepo,
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePicture: profilePicture,
          coverPicture: coverPicture,
          gender: gender,
          bio: bio,
          province: province,
          savedLectures: savedLectures,
          savedVideos: savedVideos,
          savedQuizes: savedQuizes,
        );

  SchoolUser.fromJSON(Map<String, dynamic> json)
      : schoolSection = json['school_section'],
        school = json['school'],
        subRegion = json['subRegion'],
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'school_section': schoolSection,
        'school': school,
        'subRegion': subRegion,
      }..addAll(super.toJSON());
}
