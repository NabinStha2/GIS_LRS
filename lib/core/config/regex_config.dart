class RegexConfig {
  static RegExp numberRegex = RegExp('[0-9]');
  static RegExp textRegex = RegExp('[a-zA-Z]');
  static RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static RegExp phoneNumberRegrex = RegExp(r'^[9][7-8]\d{8}$');

  static RegExp searchRegrex = RegExp('[a-zA-Z0-9- ]');
  static RegExp fullNameTextRegrex = RegExp('[a-zA-Z ]');

  static RegExp oneSpaceBetweenWords = RegExp(r'^(\w+ ?)*$');
}
