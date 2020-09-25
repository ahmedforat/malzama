class CommonFields {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String account_type;
  String province;
  String subRegion;
  String one_signal_id;
  String profile_picture_ref;
  String profile_cover_ref;

  CommonFields({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.account_type,
    this.province,
    this.subRegion,
    this.one_signal_id,
    this.profile_picture_ref,
    this.profile_cover_ref,
  });

  factory CommonFields.fromJSON({Map<String,dynamic> map}) => CommonFields(
        id: map['_id'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        email: map['email'],
        phone: map['phoneNumber'],
        account_type: map['account_type'],
        gender: map['gender'],
        province: map['province'],
        subRegion: map['subRegion'],
        one_signal_id: map['one_signal_id'],
        profile_picture_ref: map['profile_picture_ref'],
        profile_cover_ref: map['profile_cover_ref'],
      );

  Map<String,dynamic> toJSON() => {
        '_id': this.id,
        'firstName': this.firstName,
        'lastName': this.lastName,
        'email': this.email,
        'phoneNumber': this.phone,
        'gender': this.gender,
        'account_type': this.account_type,
        'province': this.province,
        'subRegion': this.subRegion,
        'one_sginal_id': this.one_signal_id,
        'profile_picture_ref': this.profile_picture_ref,
        'profile_cover_ref': this.profile_cover_ref,
      };
}
