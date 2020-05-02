class CommonFields {
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String account_type;
  String province;
  String subRegion;

  CommonFields(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender,
      this.account_type,
      this.province,
      this.subRegion});

  factory CommonFields.fromJSON({Map map}) => CommonFields(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phoneNumber'],
      account_type: map['account_type'],
      gender: map['gender'],
      province: map['province'],
      subRegion: map['subRegion']);

  Map toJSON() => {
    'firstName':this.firstName,
    'lastName':this.lastName,
    'email':this.email,
    'phone':this.phone,
    'gender':this.gender,
    'account_type':this.account_type,
    'province':this.province,
    'subRegion':this.subRegion
  };
}
