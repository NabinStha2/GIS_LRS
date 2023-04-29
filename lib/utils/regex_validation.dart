class RegexValidation {
  static bool checkEmail(String email) {
    return !RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
  }

  static RegExp digitAndDecimalOnly() {
    return RegExp(r'^\d+\.?\d{0,2}');
  }

  static RegExp digitOnly() {
    return RegExp(r'[0-9]');
  }
}
