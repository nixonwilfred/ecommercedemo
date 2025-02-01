class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  String name = "";
  String phone = "";

  void clear() {
    name = "";
    phone = "";
  }
}
