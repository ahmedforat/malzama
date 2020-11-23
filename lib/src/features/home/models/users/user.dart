class User {
  // basics
  String id;
  String oneSignalId;
  String accountType;
  String notificationsRepo;
  String uuid;

  //personal
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String coverPicture;
  String gender;
  String bio;
  String province;

  // material relevant
  List<String> savedLectures;
  List<String> savedVideos;
  List<String> savedQuizes;

  User({
    this.id,
    this.uuid,
    this.oneSignalId,
    this.accountType,
    this.notificationsRepo,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePicture,
    this.coverPicture,
    this.gender,
    this.bio,
    this.province,
    this.savedLectures,
    this.savedVideos,
    this.savedQuizes,
  });

  User.fromJSON(Map<String, dynamic> json)
      : this.id = json['_id'],
        this.uuid = json['uuid'],
        this.oneSignalId = json['one_signal_id'],
        this.accountType = json['account_type'],
        this.notificationsRepo = json['notifications_repo'],
        this.firstName = json['firstName'],
        this.lastName = json['lastName'],
        this.email = json['email'],
        this.profilePicture = json['profile_picture_ref'],
        this.coverPicture = json['profile_cover_ref'],
        this.gender = json['gender'],
        this.bio = json['bio'],
        this.province = json['province'],
        this.savedLectures = List<String>.from(json['saved_lectures']),
        this.savedVideos = List<String>.from(json['saved_videos']),
        this.savedQuizes = List<String>.from(json['saved_quizes']);

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'uuid': uuid,
        'one_signal_id': oneSignalId,
        'account_type': accountType,
        'notifications_repo': notificationsRepo,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profile_picture_ref': profilePicture,
        'profile_cover_ref': coverPicture,
        'gender': gender,
        'bio': bio,
        'province': province,
        'saved_lectures': savedLectures,
        'saved_videos': savedVideos,
        'saved_quizes': savedQuizes,
      };


  Map<String,String> get verifitionData => {
    'id':id,
    'accountType':accountType,
    'email':email,
  };
}
