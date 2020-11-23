import './user.dart';

class CollegeUser extends User {
  String college;
  String university;
  String section;
  List<String> lectures;
  List<String> videos;
  List<String> quizes;

  CollegeUser({
    this.college,
    this.university,
    this.section,
    this.lectures,
    this.videos,
    this.quizes,
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

  CollegeUser.fromJSON(Map<String, dynamic> json)
      : college = json['college'],
        university = json['university'],
        section = json['section'],
        lectures = List<String>.from(json['lectures']),
        videos = List<String>.from(json['videos']),
        quizes = List<String>.from(json['quizes']),
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'college': college,
        'university': university,
        'section': section,
        'lectures': lectures,
        'videos': videos,
        'quizes': quizes,
      }..addAll(super.toJSON());


  bool get isDental => new RegExp(r'سنان').hasMatch(this.college);

}
