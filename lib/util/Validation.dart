class Validation {
  static String validateEmail(String value) {
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String validatePassword(String value) {
    if (value.length < 4) {
      return 'Password must be more than 4 characters';
    }
    return null;
  }

  static String validateUserName(String value) {
    if (value.length == 0) {
      return 'Please enter username';
    }
    return null;
  }


}
