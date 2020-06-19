import 'package:flutter/cupertino.dart';

class FieldsValidators {
  static final String _thisFieldIsRequired = 'هذا الحقل مطلوب';
  static String validateFirstAndLastName({String firstName}) {
    if (firstName == null ||firstName.isEmpty) return _thisFieldIsRequired;

    RegExp firstNamePatternEn = new RegExp(r'^[A-Za-z]{3,12}$');
    RegExp firstNamePatternArabic = new RegExp(r'^[\u0621-\u064A]{3,12}$');

    if (!(firstNamePatternArabic.hasMatch(firstName) ||
        firstNamePatternEn.hasMatch(firstName))) {
      if (firstName.length > 12)
        return 'يجب ان لا يتجاوز طول الاسم اكثر من 12 حرفا';

      if (firstName.length < 3) return 'يجب ان يتكون الاسم من 3 حروف على الاقل';

      return 'يجب ان يتكون الاسم من حروف عربية او انكليزية فقط وبدون استخدام اللغتين معا';
    }
    return null;
  }

  static String vaildatePhoneNumber({String phoneNumber}) {
    if (phoneNumber.isEmpty) return _thisFieldIsRequired;

    RegExp phoneNumberPattern = new RegExp(r'^(075|077|078|079)\d{8}$');
    return phoneNumberPattern.hasMatch(phoneNumber)
        ? null
        : 'يرجى ادخال الرقم بصورة صحيحة ,من نوع اسيا او زين او كورك فقط';
  }

  static String validateEmail({String mail}) {
    if (mail == null || mail.isEmpty) return _thisFieldIsRequired;

    RegExp mailPattern = new RegExp(r'^[A-Za-z]*[\w\W]*@[a-z]{2,}\.[a-z]{3,}$');

    return mailPattern.hasMatch(mail)
        ? null
        : 'يرجى ادخال بريد الكتروني صالح للاستخدام';
  }

  static String validatePassword({String password}) {
    if (password == null || password.isEmpty) return _thisFieldIsRequired;

    if (password.length < 8) return 'يجب ان يكون طول كلمة المرور 8 على الاقل';

    if (password.length > 40)
      return 'يجب ان لا يتجاوز طول كلمة المرور اكثر من 40 حرفا';

    RegExp passwordPattern = new RegExp(r'^[\w-!@#%&.<>;]{8,40}$');
    if (!passwordPattern.hasMatch(password))
      return 'كلمة المرور يجب ان تتكون من الاحرف الانكليزية بنوعيها الكبير والصغير اضافة الى الرموز (-!@#%&.<>;) فقط';
    return null;
  }
}

class Validators {
  static validateFirstAndLastNames({String name}) {
    if (name.length == 0 || name == null) {
      return "please this field is required";
    }

    if (name.length < 3) {
      return "this field must be not shorter than 3 characters";
    }

    if (name.length > 14) {
      return "this field must be not longer than 14 characters";
    }

    List<String> chars = [',', '.', '/', '\\', '*', '(', ')', '%', '!'];
    bool contains = false;
    for (int i = 0; i < chars.length; i++) {
      if (name.contains(chars[i])) contains = true;
      break;
    }
    if (contains) {
      return "this field must consist of letters numbers and _  only";
    }

    if (name is num) {
      return "please use only letters and _ only";
    }

    return null;
  }

  static validateEmail({String email}) {
    if (email.isEmpty) {
      return "Please email is required";
    }
    RegExp regExp = new RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$",
        caseSensitive: true);
    bool isEmail = regExp.hasMatch(email.trim());
    if (!isEmail) {
      return "please enter a valid email like example@something.com";
    }
    return null;
  }

  static validatePhoneNumber({phoneNumber}) {
    if (phoneNumber.isEmpty) {
      return "Please phone number is required";
    }

    String phone = phoneNumber.toString();

    if (phone.length > 11 ||
        phone.length < 11 ||
        !(_validatePhoneNumber(phone))) {
      return "Please enter a valid phone number";
    }

    return null;
  }

  static _validatePhoneNumber(number) {
    RegExp zainIq = new RegExp(r"079");
    RegExp zainAtheer = new RegExp(r"078");
    RegExp asia = new RegExp(r"077");
    RegExp korek = new RegExp(r"075");

    List<String> phoneNumber = number.toString().split('');

    for (int i = 0; i < phoneNumber.length; i++) {
      try {
        int n = int.parse(phoneNumber[i]);
      } catch (err) {
        return false;
      }
    }

    if (zainIq.hasMatch(number) ||
        zainAtheer.hasMatch(number) ||
        asia.hasMatch(number) ||
        korek.hasMatch(number)) {
      return true;
    }
    return false;
  }

  static validatePassword({password}) {
    if (password.isEmpty) {
      return "Please password is required";
    }
    if (password.length < 8) {
      return "Password must be not shorter than 8 characters";
    }

    if (password.length > 30) {
      return "Password should not be longer than 30 characters";
    }

    return null;
  }
}
