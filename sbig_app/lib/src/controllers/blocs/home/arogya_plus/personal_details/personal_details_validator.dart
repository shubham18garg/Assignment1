import 'dart:async';

import 'package:sbig_app/src/utilities/email_validator.dart';

class PersonalDetailsValidator {
  static const MOBILE_EMPTY_ERROR = 1;
  static const MOBILE_LENGTH_ERROR = 2;
  static const MOBILE_INVALID_ERROR = 3;
  static const EMAIL_EMPTY_ERROR = 4;
  static const EMAIL_INVALID_ERROR = 5;

  final validateMobile = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobile, sink) {
    if (mobile.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else if (mobile.length == 10) {
      if (int.parse(mobile.substring(0, 1)) >= 6) {
        print(int.parse(mobile.substring(0, 1).toString()));
        sink.add(mobile);
      } else {
        sink.addError(MOBILE_INVALID_ERROR);
      }
    } else {
      sink.addError(MOBILE_LENGTH_ERROR);
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty) {
      sink.addError(EMAIL_EMPTY_ERROR);
    } else if (EmailValidator.validate(email)) {
      sink.add(email);
    } else {
      sink.addError(EMAIL_INVALID_ERROR);
    }
  });
}
